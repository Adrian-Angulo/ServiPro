import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_review_card.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_section_title.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';

class WorkerReviewsSection extends ConsumerWidget {
  final String workerId;
  final bool canAddReview;
  final VoidCallback? onAddReview;

  const WorkerReviewsSection({
    super.key,
    required this.workerId,
    this.canAddReview = false,
    this.onAddReview,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsByWorkerProvider(workerId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WorkerSectionTitle(title: 'Opiniones', showRightSpace: false),
            if (canAddReview && onAddReview != null)
              GestureDetector(
                onTap: onAddReview,
                child: Text(
                  'Añadir reseña',
                  style: AppTypography.labelLarge.copyWith(
                    color: const Color(0xFF319B94),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        reviewsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Text(
            'Error al cargar reseñas',
            style: TextStyle(color: const Color(0xFFEF4444)),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(
                  'Aún no hay opiniones para este trabajador.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Column(
              children: reviews.map((review) {
                final diff = DateTime.now().difference(review.createdAt);
                String timeAgo = '';
                if (diff.inDays > 0)
                  timeAgo = 'Hace ${diff.inDays} días';
                else if (diff.inHours > 0)
                  timeAgo = 'Hace ${diff.inHours} horas';
                else
                  timeAgo = 'Hace unos instantes';

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: WorkerReviewCard(
                    name: review.clientName,
                    timeAgo: timeAgo,
                    review: '"${review.comment}"',
                    rating: review.rating,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
