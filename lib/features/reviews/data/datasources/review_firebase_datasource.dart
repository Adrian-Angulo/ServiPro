import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/reviews/data/datasources/i_review_datasource.dart';
import 'package:servi_pro/features/reviews/data/models/review_model.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';

class ReviewFirebaseDatasource implements IReviewDatasource {
  final FirebaseFirestore firestore;

  ReviewFirebaseDatasource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addReview(ReviewEntity review) async {
    try {
      final model = ReviewModel(
        workerId: review.workerId,
        clientId: review.clientId,
        clientName: review.clientName,
        rating: review.rating,
        comment: review.comment,
        createdAt: review.createdAt,
      );

      await firestore.collection('reviews').add(model.toMap());
    } catch (e) {
      throw Exception('Error al guardar la reseña: $e');
    }
  }

  @override
  Future<List<ReviewEntity>> getReviewsByWorker(String workerId) async {
    try {
      final snapshot = await firestore
          .collection('reviews')
          .where('workerId', isEqualTo: workerId)
          // Sort in memory to avoid requiring a composite index in Firestore
          .get();

      final reviews = snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data(), doc.id);
      }).toList();

      // Sort by createdAt descending
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return reviews;
    } catch (e) {
      throw Exception('Error al obtener reseñas: $e');
    }
  }
}
