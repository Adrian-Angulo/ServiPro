import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:servi_pro/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<NotificationEntity>>> call(String userId) async {
    try {
      final list = await repository.getUserNotificationsStream(userId).first;
      return Right(list);
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
