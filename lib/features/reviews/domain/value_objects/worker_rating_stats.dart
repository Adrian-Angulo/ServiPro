import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';

/// Agregado de calificación derivado de reseñas (dominio puro).
class WorkerRatingStats {
  const WorkerRatingStats({
    required this.averageRating,
    required this.reviewsCount,
  });

  final double averageRating;
  final int reviewsCount;

  static WorkerRatingStats fromReviews(List<ReviewEntity> reviews) {
    if (reviews.isEmpty) {
      return const WorkerRatingStats(averageRating: 0, reviewsCount: 0);
    }
    final sum = reviews.fold<double>(0, (acc, r) => acc + r.rating);
    return WorkerRatingStats(
      averageRating: sum / reviews.length,
      reviewsCount: reviews.length,
    );
  }

  /// Lista cargada tiene prioridad; si aún no hay datos, usa valores persistidos en el perfil.
  static WorkerRatingStats resolve({
    required double storedAverage,
    required int storedCount,
    List<ReviewEntity>? loadedReviews,
  }) {
    if (loadedReviews != null && loadedReviews.isNotEmpty) {
      return fromReviews(loadedReviews);
    }
    return WorkerRatingStats(
      averageRating: storedAverage,
      reviewsCount: storedCount,
    );
  }
}
