import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servi_pro/features/notifications/data/datasources/notification_datasource.dart';
import 'package:servi_pro/features/notifications/data/models/notification_model.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';

class NotificationFirebaseDatasource implements NotificationDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    try {
      final model = NotificationModel(
        userId: notification.userId,
        type: notification.type,
        title: notification.title,
        message: notification.message,
        relatedId: notification.relatedId,
        isRead: notification.isRead,
        createdAt: notification.createdAt,
      );

      await firestore.collection('notifications').add(model.toMap());
    } catch (e) {
      throw Exception('Error al agregar notificación: $e');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByUser(String userId) async {
    try {
      final snapshot = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
      }).toList();

      return notifications;
    } catch (e) {
      throw Exception('Error al obtener notificaciones: $e');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception('Error al marcar como leída: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      throw Exception('Error al eliminar notificación: $e');
    }
  }
}
