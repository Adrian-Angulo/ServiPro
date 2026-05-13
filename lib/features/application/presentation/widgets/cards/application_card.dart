import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/core/widgets/app_time_ago.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/reviews/presentation/screens/rate_service_screen.dart';

/// Card que muestra una postulación del trabajador con el estado y datos de la solicitud.
class ApplicationCard extends ConsumerWidget {
  final ApplicationEntity application;

  final VoidCallback? onTap;

  const ApplicationCard({super.key, required this.application, this.onTap});

  String _stateApplication(ApplicationStatus application) {
    switch (application) {
      case ApplicationStatus.aceptado:
        return "ACEPTADO";
      case ApplicationStatus.postulado:
        return "POSTULADO";
      case ApplicationStatus.noDisponible:
        return "NO DISPONIBLE";
      case ApplicationStatus.finalizado:
        return "FINALIZADO";
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _markAsCompleted(BuildContext context, WidgetRef ref) async {
    try {
      final usecase = ref.read(markRequestCompletedProvider);
      final result = await usecase(
        requestId: application.idrequest,
        workerId: application.idworker,
      );

      result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${failure.message}')),
            );
          }
        },
        (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Servicio marcado como completado')),
            );
            // Refresh worker applications
            ref.invalidate(workerApplicationsProvider);
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _confirmCompletion(BuildContext context, WidgetRef ref) async {
    try {
      final usecase = ref.read(confirmRequestCompletionProvider);
      final authState = ref.read(authStateProvider);
      final requestAsync = ref.read(
        resquestByIdProvider(application.idrequest),
      );

      authState.whenData((user) async {
        if (user != null) {
          final result = await usecase(
            requestId: application.idrequest,
            clientId: user.id,
          );

          result.fold(
            (failure) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${failure.message}')),
                );
              }
            },
            (_) {
              if (context.mounted) {
                // Refresh UI
                ref.invalidate(resquestByIdProvider(application.idrequest));

                // Navigate to RateServiceScreen
                final request = requestAsync.valueOrNull;
                if (request != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RateServiceScreen(
                        workerId: application.idworker,
                        workerName:
                            'Trabajador', // Se puede mejorar obteniendo el nombre real
                        requestId: application.idrequest,
                        applicationId: application.id,
                        clientId: user.id,
                        clientName: user.email.split('@').first,
                      ),
                    ),
                  );
                }
              }
            },
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(resquestByIdProvider(application.idrequest));

    return GestureDetector(
      onTap: () {
        final request = requestAsync.valueOrNull;
        if (request != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerDetallesSolicitudScreen(request: request),
            ),
          );
        }
      },
      child: Card(
        color: AppColors.background,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Barra vertical de estado (izquierda)
                Container(
                  width: 6,
                  decoration: BoxDecoration(color: Color(0xFF1E3A5F)),
                ),

                // Contenido principal
                requestAsync.when(
                  data: (request) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Estado y tiempo
                            Row(
                              spacing: AppSpacing.md,
                              children: [
                                Text(
                                  (request.status == ServiceStatus.inProgress ||
                                              request.status ==
                                                  ServiceStatus.completed) &&
                                          application.state !=
                                              ApplicationStatus.aceptado &&
                                          application.state !=
                                              ApplicationStatus.finalizado
                                      ? "ASIGNADO A OTRO"
                                      : _stateApplication(application.state),
                                  style: TextStyle(
                                    color:
                                        (request.status ==
                                                    ServiceStatus.inProgress ||
                                                request.status ==
                                                    ServiceStatus.completed) &&
                                            application.state !=
                                                ApplicationStatus.aceptado &&
                                            application.state !=
                                                ApplicationStatus.finalizado
                                        ? Colors.orange.shade700
                                        : const Color.fromRGBO(
                                            100,
                                            116,
                                            139,
                                            1,
                                          ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                AppTimeAgo(date: application.createdAt),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // Título
                            Text(
                              request.title,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: AppSpacing.xs),

                            // Descripción
                            Text(
                              request.addres,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.grey700,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Botones de acción
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: AppSpacing.md,
                              children: [
                                // Botón: Marcar como completado (solo para trabajadores cuando state == aceptado)
                                if (application.state ==
                                        ApplicationStatus.aceptado &&
                                    request.status == ServiceStatus.inProgress)
                                  ElevatedButton.icon(
                                    onPressed: () => _showConfirmDialog(
                                      context,
                                      ref,
                                      'Marcar como completado',
                                      '¿Has finalizado este servicio? El cliente deberá confirmar.',
                                      () => _markAsCompleted(context, ref),
                                    ),
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Marcar como completado'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.lg,
                                        vertical: AppSpacing.xs,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusMd,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Botón: Confirmar finalización (solo para clientes cuando status == awaitingConfirmation)
                                if (request.status ==
                                    ServiceStatus.awaitingConfirmation)
                                  ElevatedButton.icon(
                                    onPressed: () => _showConfirmDialog(
                                      context,
                                      ref,
                                      'Confirmar finalización',
                                      '¿El servicio fue completado satisfactoriamente?',
                                      () => _confirmCompletion(context, ref),
                                    ),
                                    icon: const Icon(Icons.verified),
                                    label: const Text('Confirmar finalización'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.lg,
                                        vertical: AppSpacing.xs,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusMd,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Botón: Cancelar Solicitud
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A5F),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.xl,
                                      vertical: AppSpacing.xs,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusMd,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: AppTypography.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: Text(
                            'Error al cargar la solicitud',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
