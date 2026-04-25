import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/time_formatter.dart';
import 'package:servi_pro/core/widgets/empty/empty_state_widget.dart';
import 'package:servi_pro/core/widgets/feedback/error_retry_widget.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/request_card.dart';

class SolicitudesWorkerScreen extends ConsumerWidget {
  const SolicitudesWorkerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestNotifierProvider);
    final applicationsAsync = ref.watch(workerApplicationsProvider);
    final user = ref.watch(authNotifierProvider).value;
    final postulationState = ref.watch(addAppliNotifier);

    final appliedRequestIds =
        applicationsAsync.valueOrNull?.map((a) => a.idrequest).toSet() ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Solicitudes disponibles', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: requestsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        error: (_, __) => ErrorRetryWidget(
          message: 'Error al cargar solicitudes',
          onRetry: () => ref.invalidate(requestNotifierProvider),
        ),
        data: (requests) {
          final available = requests
              .where((r) => !appliedRequestIds.contains(r.id))
              .toList();

          if (available.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'No hay solicitudes disponibles',
              subtitle: 'Ya te postulaste a todas las solicitudes activas',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(requestNotifierProvider);
              if (user != null) {
                await ref
                    .read(workerApplicationsProvider.notifier)
                    .load(user.id);
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              itemCount: available.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final request = available[index];
                final isLoading = postulationState is AsyncLoading;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerDetallesSolicitudScreen(
                        request: request,
                        isWorkerView: true,
                        alreadyApplied: false,
                      ),
                    ),
                  ),
                  child: RequestCard(
                    status: request.status,
                    title: request.title,
                    description: request.details,
                    time: TimeFormatter.timeAgo(request.dateCreated),
                    onPress: isLoading
                        ? null
                        : () async {
                            if (user == null) return;
                            await ref
                                .read(addAppliNotifier.notifier)
                                .addApplication(
                                  idWorker: user.id,
                                  idRequest: request.id!,
                                );
                            final result = ref.read(addAppliNotifier);
                            if (!context.mounted) return;
                            if (result is AsyncError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Error al postularse. Intenta de nuevo.',
                                  ),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              await ref
                                  .read(workerApplicationsProvider.notifier)
                                  .load(user.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text('¡Postulación enviada!'),
                                      ],
                                    ),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
