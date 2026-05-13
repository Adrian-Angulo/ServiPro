import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/domain/repositories/review_repository.dart';

class AddReviewUsecase {
  final ReviewRepository repository;

  AddReviewUsecase(this.repository);

  Future<Either<Failure, Unit>> call(ReviewEntity review) {
    return repository.addReview(review);
  }
}
