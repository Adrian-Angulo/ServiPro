import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/application/data/repositories/application_repository_impl.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/domain/usecases/add_application_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/cancel_application_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/accept_application_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/complete_request_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_request_usecase.dart';
import 'package:servi_pro/features/application/domain/usecases/get_applications_for_worker_usecase.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';

final repoApplicationProvider = Provider((ref) {
  return ApplicationRepositoryImpl();
});

final addApliUsecaseProvider = Provider((ref) {
  return AddApplicationUsecase(repository: ref.read(repoApplicationProvider));
});

final cancelApliUsecaseProvider = Provider((ref) {
  return CancelApplicationUsecase(repository: ref.read(repoApplicationProvider));
});

final acceptApliUsecaseProvider = Provider((ref) {
  return AcceptApplicationUsecase(ref.read(repoApplicationProvider));
});

final completeRequestUsecaseProvider = Provider((ref) {
  return CompleteRequestUsecase(ref.read(repoApplicationProvider));
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
  Future<List<ApplicationEntity>> build() async {
    final user = ref.watch(authNotifierProvider).value;
    if (user == null) return [];
    return _fetchApplications(user.id);
  }

  Future<List<ApplicationEntity>> _fetchApplications(String idWorker) async {
    final usecase = ref.read(getAppliForWorkerUsecaseProvider);
    final result = await usecase(idWorker: idWorker);
    return result.fold((failure) => throw failure, (list) => list);
  }

  Future<void> refresh() async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchApplications(user.id));
  }

  void addOptimistic(ApplicationEntity app) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, app]);
  }

  void removeOptimistic(String applicationId) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((a) => a.id != applicationId).toList());
  }
}

final workerApplicationsProvider =
    AsyncNotifierProvider<WorkerApplicationsNotifier, List<ApplicationEntity>>(
      WorkerApplicationsNotifier.new,
    );

// Postulaciones por solicitud (para el cliente)
// Provider de tipo FutureProvider.family que recibe un idRequest como parámetro
// y retorna la lista de postulaciones asociadas a esa solicitud específica.
// Se usa .family para poder pasar el idRequest dinámicamente desde la UI.
final applicationsByRequestProvider =
    FutureProvider.family<List<ApplicationEntity>, String>((
      ref,
      idRequest,
    ) async {
      // Obtiene el caso de uso encargado de consultar postulaciones por solicitud
      final usecase = ref.read(getAppliForRequestUsecaseProvider);

      // Ejecuta el caso de uso pasando el id de la solicitud
      final result = await usecase(idRequest: idRequest);

      // Si hay un fallo, lo lanza como excepción para que el provider lo capture como AsyncError.
      // Si es exitoso, retorna la lista de postulaciones.
      return result.fold((failure) => throw failure, (list) => list);
    });



final alreadyAppliedProvider = Provider.family<bool, String>((ref, requestId) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return false;

  final applications = ref.watch(workerApplicationsProvider).value;
  if (applications == null) return false;

  return applications.any(
    (p) => p.idworker == user.id && p.idrequest == requestId,
  );
});
