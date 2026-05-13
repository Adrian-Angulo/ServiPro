import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:servi_pro/features/notifications/domain/entities/notification_entity.dart';
import 'package:servi_pro/features/notifications/domain/repositories/notification_repository.dart';
import 'package:servi_pro/features/notifications/domain/usecases/add_notification_usecase.dart';
import 'package:servi_pro/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

final addNotificationUsecaseProvider = Provider((ref) {
  return AddNotificationUsecase(
    repository: ref.read(notificationRepositoryProvider),
  );
});

final markNotificationAsReadUsecaseProvider = Provider((ref) {
  return MarkNotificationAsReadUsecase(
    repository: ref.read(notificationRepositoryProvider),
  );
});

final userNotificationsProvider =
    StreamProvider.family<List<NotificationEntity>, String>((ref, userId) {
  final repository = ref.read(notificationRepositoryProvider);
  return repository.getUserNotificationsStream(userId);
});

final unreadCountProvider = Provider.family<int, String>((ref, userId) {
  final notifications = ref.watch(userNotificationsProvider(userId));
  return notifications.when(
    data: (list) => list.where((n) => !n.isRead).length,
    loading: () => 0,
    error: (e, st) => 0,
  );
});

class AddNotificationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addNotification(NotificationEntity notification) async {
    state = const AsyncLoading();
    final usecase = ref.read(addNotificationUsecaseProvider);
    final result = await usecase(notification);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final addNotificationNotifierProvider =
    AsyncNotifierProvider<AddNotificationNotifier, void>(() {
  return AddNotificationNotifier();
});
