import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/category_helper.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/core/utils/time_formatter.dart';
import 'package:servi_pro/core/widgets/badge/status_badge.dart';
import 'package:servi_pro/core/widgets/buttons/bottom_action_button.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/postulaciones_section.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/count_postulaciones_widget.dart';

class VerDetallesSolicitudScreen extends ConsumerWidget {
  final RequestEntity request;

  const VerDetallesSolicitudScreen({super.key, required this.request});

  Future<void> _cancelRequest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text('¿Cancelar solicitud?', style: AppTypography.titleMedium),
        content: Text(
          'Esta acción no se puede deshacer. La solicitud será eliminada permanentemente.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'No',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sí, cancelar',
              style: AppTypography.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final failure = await ref
        .read(requestNotifierProvider.notifier)
        .deleteRequest(id: request.id!);

    if (!context.mounted) return;

    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Solicitud cancelada'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _applyToRequest(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;
    ref.invalidate(applicationsByRequestProvider(request.id!));

    await ref
        .read(addAppliNotifier.notifier)
        .addApplication(idWorker: user.id, idRequest: request.id!);

    if (!context.mounted) return;
    
    // NOTA: Usamos ref.read en lugar de ref.watch dentro de un callback para evitar warnings
    final result = ref.read(addAppliNotifier);

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al postularse. Intenta de nuevo.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // 1. Incrementamos el contador local para que la UI se actualice
      request.postulationsCount++;
      
      // 2. Forzamos a Riverpod a repintar la lista de solicitudes anterior
      // clonando la lista actual, así la tarjeta en la pantalla anterior se actualiza.
      final currentRequests = ref.read(requestNotifierProvider).valueOrNull;
      if (currentRequests != null) {
        // En Riverpod, reasignar el state notifica a los listeners (la UI)
        ref.read(requestNotifierProvider.notifier).state = AsyncData([...currentRequests]);
      }

      // 3. Recargar postulaciones para actualizar el filtro
      await ref.read(workerApplicationsProvider.notifier).refresh();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('¡Postulación enviada!'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _cancelApplication(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;
    
    final applications = ref.read(workerApplicationsProvider).value;
    if (applications == null) return;
    
    // Buscar la postulación correspondiente
    final application = applications.where((p) => p.idworker == user.id && p.idrequest == request.id).firstOrNull;
    if (application == null || application.id == null) return;

    final wasAccepted = application.state == ApplicationStatus.aceptado;

    ref.invalidate(applicationsByRequestProvider(request.id!));

    await ref
        .read(addAppliNotifier.notifier)
        .cancelApplication(id: application.id!, idRequest: request.id!);

    if (!context.mounted) return;
    
    final result = ref.read(addAppliNotifier);

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al cancelar la postulación. Intenta de nuevo.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // 1. Actualizamos contador y estado si la postulación estaba aceptada
      if (request.postulationsCount > 0) request.postulationsCount--;
      if (wasAccepted) {
        request.status = ServiceStatus.pending;
        request.dateAssigned = null;
      }
      
      // 2. Forzamos a Riverpod a repintar la lista de solicitudes anterior
      final currentRequests = ref.read(requestNotifierProvider).valueOrNull;
      if (currentRequests != null) {
        ref.read(requestNotifierProvider.notifier).state = AsyncData([...currentRequests]);
      }

      // 3. Recargar postulaciones para actualizar el filtro
      await ref.read(workerApplicationsProvider.notifier).refresh();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Postulación cancelada.'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _showCompleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text('Finalizar Servicio', style: AppTypography.titleLarge),
            ],
          ),
          content: Text(
            '¿Confirmas que el trabajador ha finalizado este servicio satisfactoriamente?',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.grey700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar', style: TextStyle(color: AppColors.grey700)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
              child: Text('Sí, Finalizar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _completeRequest(context, ref);
    }
  }

  Future<void> _completeRequest(BuildContext context, WidgetRef ref) async {
    final apps = ref.read(applicationsByRequestProvider(request.id!)).valueOrNull;
    final acceptedApp = apps?.where((a) => a.state == ApplicationStatus.aceptado).firstOrNull;
    
    if (acceptedApp == null) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: No se encontró al trabajador asignado.'), backgroundColor: AppColors.error),
       );
       return;
    }

    await ref.read(addAppliNotifier.notifier).completeRequest(
      applicationId: acceptedApp.id, 
      requestId: request.id!
    );

    if (!context.mounted) return;
    
    final result = ref.read(addAppliNotifier);

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al finalizar el servicio. Intenta de nuevo.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // 1. Actualizamos localmente
      request.status = ServiceStatus.completed;
      request.dateFinish = DateTime.now();
      
      // 2. Forzamos a Riverpod a repintar
      final currentRequests = ref.read(requestNotifierProvider).valueOrNull;
      if (currentRequests != null) {
        ref.read(requestNotifierProvider.notifier).state = AsyncData([...currentRequests]);
      }
      
      ref.invalidate(applicationsByRequestProvider(request.id!));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Trabajo finalizado con éxito.'),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    final alreadyApplied = ref.watch(alreadyAppliedProvider(request.id!));
    final isWorkerView = user!.rol == Rol.trabajador;
    final uiStatus = request.status;
    final isPending = uiStatus == ServiceStatus.pending;
    final postulationState = ref.watch(addAppliNotifier);
    final isLoading = postulationState is AsyncLoading;

    bool isAcceptedWorker = false;
    bool isAssignedToOther = false;

    if (isWorkerView) {
      final applications = ref.watch(workerApplicationsProvider).valueOrNull;
      if (applications != null) {
        final myApplication = applications.where((p) => p.idrequest == request.id).firstOrNull;
        if (myApplication != null && myApplication.state == ApplicationStatus.aceptado) {
          isAcceptedWorker = true;
        } else if (uiStatus == ServiceStatus.inProgress) {
          isAssignedToOther = true;
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: request.status),
                CategoryHelper.getIconWithLabel(request.idTypeService),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(request.title, style: AppTypography.titleLarge),
            SizedBox(height: AppSpacing.xl),
            Row(
              spacing: AppSpacing.md,
              children: [
                ServiceDateItem(
                  color: Colors.green,
                  date: request.dateCreated,
                  icon: Icons.calendar_month_outlined,
                  title: 'Publicado',
                ),

                if (request.dateAssigned != null) ...[
                  Container(width: 1, height: 40, color: AppColors.grey500),
                  ServiceDateItem(
                    color: Colors.amber,
                    date: request.dateAssigned!,
                    icon: Icons.person,
                    title: 'Asignado',
                  ),
                ],

                if (request.dateFinish != null) ...[
                  Container(width: 1, height: 40, color: AppColors.grey500),
                  ServiceDateItem(
                    color: Colors.blue,
                    date: request.dateFinish!,
                    icon: Icons.check_circle_outline_outlined,
                    title: 'Finalizado',
                  ),
                ],

                if (isWorkerView && request.status == ServiceStatus.pending) CountPostulacionesWidget(request: request),
              ],
            ),
            
            if (isAcceptedWorker) ...[
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: Colors.green.shade300, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Felicidades!',
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'El cliente te ha asignado a esta solicitud.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (isAssignedToOther) ...[
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: Colors.orange.shade300, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solicitud Asignada',
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Esta solicitud ya fue asignada a otro trabajador.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey500.withOpacity(0.5),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Descripción del problema",
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          request.details,
                          style: AppTypography.bodyMedium,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey500.withOpacity(0.5),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dirección", style: AppTypography.labelLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          request.addres,
                          style: AppTypography.bodyMedium,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isWorkerView) ...[
                      const SizedBox(height: AppSpacing.xl),
                      PostulacionesSection(request: request),
                    ],
                  ],
                ),
              ),
            ),

            // Botón inferior — varía según el rol
            if (isWorkerView)
              BottomActionButton(
                label: alreadyApplied ? 'Cancelar Postulacion' : 'Postularme',
                onPressed: () {
                   if (alreadyApplied) {
                      _cancelApplication(context, ref);
                   } else if (isPending) {
                      _applyToRequest(context, ref);
                   }
                },
                isLoading: isLoading,
                backgroundColor: alreadyApplied
                    ? AppColors.error
                    : AppColors.primary,
              )
            else if (isPending)
              BottomActionButton(
                label: 'Cancelar Solicitud',
                onPressed: () => _cancelRequest(context, ref),
                isLoading: isLoading,
                backgroundColor: AppColors.accent,
              )
            else if (!isWorkerView && uiStatus == ServiceStatus.inProgress)
              BottomActionButton(
                label: 'Finalizar Trabajo',
                onPressed: () => _showCompleteConfirmation(context, ref),
                isLoading: isLoading,
                backgroundColor: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceDateItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final DateTime date;

  const ServiceDateItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              Text(
                TimeFormatter.shortDate(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
