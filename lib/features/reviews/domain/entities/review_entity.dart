class ReviewEntity {
  String? id;
  final String workerId;
  final String clientId;
  final String clientName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewEntity({
    this.id,
    required this.workerId,
    required this.clientId,
    required this.clientName,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
