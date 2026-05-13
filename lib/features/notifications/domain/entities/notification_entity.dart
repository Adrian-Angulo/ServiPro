enum NotificationType {
  newRequest,
  newApplication,
  applicationAccepted,
  serviceCompleted,
  newReview,
  serviceConfirmed,
}

class NotificationEntity {
  String? id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? relatedId;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
