import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_avatar_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_stats_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_about_section.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_reviews_section.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_contact_bottom_sheet.dart';
import 'package:servi_pro/features/reviews/domain/value_objects/worker_rating_stats.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';

class WorkerPerfilSimpleView extends ConsumerWidget {
  final String workerId;

  const WorkerPerfilSimpleView({super.key, required this.workerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerAsync = ref.watch(workerByIdProvider(workerId));

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

                // Email
                Text(
                  worker.email.isNotEmpty ? worker.email : '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const SizedBox(height: AppSpacing.xs),

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
                WorkerReviewsSection(workerId: worker.id),
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
              child: ElevatedButton.icon(
                onPressed: () =>
                    WorkerContactBottomSheet.show(context, worker.celular),
                icon: const Icon(Icons.contact_phone_rounded, size: 20),
                label: Text(
                  'Contactar',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
