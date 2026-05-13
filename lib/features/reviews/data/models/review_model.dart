import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    super.id,
    required super.workerId,
    required super.clientId,
    required super.clientName,
    required super.rating,
    required super.comment,
    required super.requestId,
    required super.applicationId,
    super.isVerified = true,
    super.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      workerId: map['workerId'],
      clientId: map['clientId'],
      clientName: map['clientName'] ?? 'Cliente Anónimo',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      requestId: map['requestId'] ?? '',
      applicationId: map['applicationId'] ?? '',
      isVerified: map['isVerified'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workerId': workerId,
      'clientId': clientId,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'requestId': requestId,
      'applicationId': applicationId,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
