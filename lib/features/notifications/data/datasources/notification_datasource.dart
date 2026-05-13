import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationDatasource {
  Future<void> addNotification(NotificationEntity notification);
  Future<List<NotificationEntity>> getNotificationsByUser(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}
