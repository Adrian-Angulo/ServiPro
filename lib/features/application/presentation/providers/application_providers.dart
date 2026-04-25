import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/application/data/repositories/application_repository_impl.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/domain/usecases/add_application_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_request_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_worker_usecase.dart';

final repoApplicationProvider = Provider((ref) {
  return ApplicationRepositoryImpl();
});

final addApliUsecaseProvider = Provider((ref) {
  return AddApplicationUsecase(repository: ref.read(repoApplicationProvider));
});

final getAppliForWorkerUsecaseProvider = Provider((ref) {
  return GetApplicationsForWorkerUsecase(
    repository: ref.read(repoApplicationProvider),
  );
});

final getAppliForRequestUsecaseProvider = Provider((ref) {
  return GetApplicationsForRequestUsecase(
    repository: ref.read(repoApplicationProvider),
  );
});

// Postulaciones del trabajador
class WorkerApplicationsNotifier
    extends AsyncNotifier<List<ApplicationEntity>> {
  @override
  Future<List<ApplicationEntity>> build() async => [];

  Future<void> load(String idWorker) async {
    state = const AsyncLoading();
    final usecase = ref.read(getAppliForWorkerUsecaseProvider);
    final result = await usecase(idWorker: idWorker);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (list) => AsyncData(list),
    );
  }

  void addOptimistic(ApplicationEntity app) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, app]);
  }
}

final workerApplicationsProvider =
    AsyncNotifierProvider<WorkerApplicationsNotifier, List<ApplicationEntity>>(
      WorkerApplicationsNotifier.new,
    );

// Postulaciones por solicitud (para el cliente)
final applicationsByRequestProvider =
    FutureProvider.family<List<ApplicationEntity>, String>((
      ref,
      idRequest,
    ) async {
      final usecase = ref.read(getAppliForRequestUsecaseProvider);
      final result = await usecase(idRequest: idRequest);
      return result.fold((failure) => throw failure, (list) => list);
    });
