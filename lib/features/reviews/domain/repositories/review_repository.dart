import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, Unit>> addReview(ReviewEntity review);
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByWorker(String workerId);
}
