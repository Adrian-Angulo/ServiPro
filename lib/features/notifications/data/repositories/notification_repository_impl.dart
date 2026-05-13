import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/notifications/data/models/notification_model.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:servi_pro/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationRepositoryImpl();

  @override
  Future<Either<Failure, Unit>> create(NotificationEntity notification) async {
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
      await _firestore.collection('notifications').add(model.toMap());
      return Right(unit);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<NotificationEntity>> getUserNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NotificationModel.fromMap(data, doc.id);
          }).toList();
        });
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      return Right(unit);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) {
        return Right(unit);
      }

      const maxBatchSize = 500;
      final docs = snapshot.docs;
      for (var i = 0; i < docs.length; i += maxBatchSize) {
        final batch = _firestore.batch();
        final end = (i + maxBatchSize > docs.length) ? docs.length : i + maxBatchSize;
        for (var j = i; j < end; j++) {
          batch.update(docs[j].reference, {'isRead': true});
        }
        await batch.commit();
      }

      return Right(unit);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
