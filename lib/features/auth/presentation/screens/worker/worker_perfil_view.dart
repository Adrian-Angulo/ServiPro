import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/reviews/domain/value_objects/worker_rating_stats.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';
import 'package:servi_pro/features/reviews/presentation/widgets/add_review_dialog.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_avatar_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_stats_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_about_section.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_reviews_section.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_contact_bottom_sheet.dart';

class WorkerPerfilView extends ConsumerStatefulWidget {
  final String workerId;
  final String? applicationId;
  final RequestEntity? request;

  const WorkerPerfilView({
    super.key,
    required this.workerId,
    this.applicationId,
    this.request,
  });

  @override
  ConsumerState<WorkerPerfilView> createState() => _WorkerPerfilViewState();
}

class _WorkerPerfilViewState extends ConsumerState<WorkerPerfilView> {
  bool isLoading = false;

  Future<void> _acceptWorker() async {
    setState(() => isLoading = true);

    await ref
        .read(addAppliNotifier.notifier)
        .acceptApplication(
          applicationId: widget.applicationId!,
          requestId: widget.request!.id!,
        );

    if (!mounted) return;

    final result = ref.read(addAppliNotifier);

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Error al aceptar la postulación. Intenta de nuevo.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => isLoading = false);
    } else {
      // Actualización instantánea en la UI
      widget.request!.status = ServiceStatus.inProgress;

      final currentRequests = ref.read(requestNotifierProvider).valueOrNull;
      if (currentRequests != null) {
        ref.read(requestNotifierProvider.notifier).state = AsyncData([
          ...currentRequests,
        ]);
      }

      ref.invalidate(applicationsByRequestProvider(widget.request!.id!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Trabajador aceptado exitosamente.'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() => isLoading = false);
      Navigator.pop(context);
    }
  }

  void _showAddReviewDialog() {
    if (widget.request?.id == null || widget.applicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede agregar reseña en este momento'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        workerId: widget.workerId,
        requestId: widget.request!.id!,
        applicationId: widget.applicationId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerAsync = ref.watch(workerByIdProvider(widget.workerId));
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey900,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil Profesional',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: workerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar el perfil',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
        data: (worker) {
          if (worker == null) {
            return Center(
              child: Text(
                'Trabajador no encontrado',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                WorkerAvatarWidget(imageUrl: null, showVerifiedBadge: false),
                const SizedBox(height: AppSpacing.md),

                // Nombre
                Text(
                  worker.nombreCompleto,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  worker.email.isNotEmpty ? worker.email : '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  worker.profesion.isNotEmpty ? worker.profesion : '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Ubicación
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      worker.ciudad.isNotEmpty ? worker.ciudad : '',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Estadísticas
                Consumer(
                  builder: (context, ref, child) {
                    final reviewsAsync = ref.watch(
                      reviewsByWorkerProvider(worker.id),
                    );
                    final stats = WorkerRatingStats.resolve(
                      storedAverage: worker.averageRating,
                      storedCount: worker.reviewsCount,
                      loadedReviews: reviewsAsync.valueOrNull,
                    );
                    return WorkerStatsWidget(
                      rating: stats.averageRating,
                      reviewsCount: stats.reviewsCount,
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Sobre mi
                WorkerAboutSection(aboutText: worker.sobreMi),
                const SizedBox(height: 32),

                // Opiniones
                Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(authNotifierProvider).value;
                    final isClient = user?.rol == Rol.cliente;
                    final isCompleted =
                        widget.request?.status == ServiceStatus.completed;

                    return WorkerReviewsSection(
                      workerId: worker.id,
                      canAddReview: isClient && isCompleted == true,
                      onAddReview: _showAddReviewDialog,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: workerAsync.whenOrNull(
        data: (worker) {
          if (worker == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackOverlay10.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => WorkerContactBottomSheet.show(
                        context,
                        worker.celular,
                      ),
                      icon: const Icon(Icons.contact_phone_rounded, size: 20),
                      label: Text(
                        'Contactar',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(
                          color: AppColors.accent,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  if (widget.request != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            widget.request!.status != ServiceStatus.pending ||
                                isLoading
                            ? null
                            : _acceptWorker,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                        label: Text(
                          widget.request!.status == ServiceStatus.inProgress
                              ? 'Asignado'
                              : widget.request!.status ==
                                    ServiceStatus.completed
                              ? 'Finalizado'
                              : 'Aceptar',
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
