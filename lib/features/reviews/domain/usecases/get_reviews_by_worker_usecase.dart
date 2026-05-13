import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/domain/repositories/review_repository.dart';

class GetReviewsByWorkerUsecase {
  final ReviewRepository repository;

  GetReviewsByWorkerUsecase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(String workerId) {
    return repository.getReviewsByWorker(workerId);
  }
}
