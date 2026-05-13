import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:servi_pro/features/auth/domain/usecases/get_worker_by_id_usecase.dart';
import 'package:servi_pro/features/auth/domain/usecases/get_all_workers_usecase.dart';
import 'package:servi_pro/features/auth/domain/usecases/reset_passwordk_usecase.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_notifier.dart';
import 'package:servi_pro/features/requests/domain/usecases/mark_request_completed_usecase.dart';
import 'package:servi_pro/features/requests/domain/usecases/confirm_request_completion_usecase.dart';
import 'package:servi_pro/features/requests/data/repository/request_impl.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestImpl(),
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Usuario?>(
  () => AuthNotifier(),
);

final getWorkerByIdUsecaseProvider = Provider<GetWorkerByIdUsecase>((ref) {
  return GetWorkerByIdUsecase(repository: ref.read(authRepositoryProvider));
});

final getAllWorkersUsecaseProvider = Provider<GetAllWorkersUsecase>((ref) {
  return GetAllWorkersUsecase(repository: ref.read(authRepositoryProvider));
});

final resetPasswordProvider = Provider<ResetPasswordUsecase>((ref) {
  return ResetPasswordUsecase(authRepository: ref.read(authRepositoryProvider));
});

final markRequestCompletedProvider = Provider<MarkRequestCompletedUsecase>((
  ref,
) {
  return MarkRequestCompletedUsecase(
    repository: ref.read(requestRepositoryProvider),
  );
});

final confirmRequestCompletionProvider =
    Provider<ConfirmRequestCompletionUsecase>((ref) {
      return ConfirmRequestCompletionUsecase(
        repository: ref.read(requestRepositoryProvider),
      );
    });

final workerByIdProvider = FutureProvider.family<Trabajador?, String>((
  ref,
  workerId,
) async {
  final usecase = ref.read(getWorkerByIdUsecaseProvider);
  return usecase(id: workerId);
});

final allWorkersProvider = FutureProvider<List<Trabajador>>((ref) async {
  final usecase = ref.read(getAllWorkersUsecaseProvider);
  final users = await usecase();
  return users.whereType<Trabajador>().toList();
});

final recommendedWorkersProvider = FutureProvider<List<Trabajador>>((
  ref,
) async {
  final usecase = ref.read(getAllWorkersUsecaseProvider);
  final users = await usecase();
  final workers = users.whereType<Trabajador>().toList();
  return workers.take(5).toList();
});

final authStateProvider = StreamProvider<Usuario?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges();
});
