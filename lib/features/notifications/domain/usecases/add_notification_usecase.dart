import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:servi_pro/features/notifications/domain/repositories/notification_repository.dart';

class AddNotificationUsecase {
  final NotificationRepository repository;

  AddNotificationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(NotificationEntity notification) async {
    return repository.create(notification);
  }
}
