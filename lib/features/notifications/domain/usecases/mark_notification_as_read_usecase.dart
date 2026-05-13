import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository repository;

  MarkNotificationAsReadUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(String notificationId) async {
    return repository.markAsRead(notificationId);
  }
}
