import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:servi_pro/features/auth/domain/usecases/get_worker_by_id_usecase.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Usuario?>(
  () => AuthNotifier(),
);

final getWorkerByIdUsecaseProvider = Provider<GetWorkerByIdUsecase>((ref) {
  return GetWorkerByIdUsecase(repository: ref.read(authRepositoryProvider));
});

final workerByIdProvider = FutureProvider.family<Trabajador?, String>((
  ref,
  workerId,
) async {
  final usecase = ref.read(getWorkerByIdUsecaseProvider);
  return usecase(id: workerId);
});

final authStateProvider = StreamProvider<Usuario?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges();
});
