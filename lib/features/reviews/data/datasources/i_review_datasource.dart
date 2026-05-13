import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';

abstract class IReviewDatasource {
  Future<void> addReview(ReviewEntity review);
  Future<List<ReviewEntity>> getReviewsByWorker(String workerId);
}
