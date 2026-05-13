import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:servi_pro/features/reviews/data/datasources/i_review_datasource.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/domain/repositories/review_repository.dart';
import 'package:servi_pro/features/reviews/domain/value_objects/worker_rating_stats.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final IReviewDatasource datasource;
  final AuthRepository authRepository;

  ReviewRepositoryImpl(this.datasource, this.authRepository);

  @override
  Future<Either<Failure, Unit>> addReview(ReviewEntity review) async {
    try {
      await datasource.addReview(review);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
    try {
      await _syncWorkerRating(review.workerId);
    } catch (_) {
      // La reseña ya está guardada; el documento del trabajador puede reconciliarse al recargar.
    }
    return Right(unit);
  }

  Future<void> _syncWorkerRating(String workerId) async {
    final reviews = await datasource.getReviewsByWorker(workerId);
    final stats = WorkerRatingStats.fromReviews(reviews);
    await authRepository.syncWorkerRatingStats(
      workerId: workerId,
      averageRating: stats.averageRating,
      reviewsCount: stats.reviewsCount,
    );
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByWorker(String workerId) async {
    try {
      final reviews = await datasource.getReviewsByWorker(workerId);
      return Right(reviews);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
