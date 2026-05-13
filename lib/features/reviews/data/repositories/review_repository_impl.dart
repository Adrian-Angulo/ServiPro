import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/reviews/data/datasources/i_review_datasource.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final IReviewDatasource datasource;

  ReviewRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Unit>> addReview(ReviewEntity review) async {
    try {
      await datasource.addReview(review);
      return Right(unit);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
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
