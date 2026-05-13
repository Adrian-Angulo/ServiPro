import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/requests/data/repository/request_impl.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';
import 'package:servi_pro/features/requests/domain/usecases/deleted_request_use_case.dart';
import 'package:servi_pro/features/requests/domain/usecases/get_all_requests_use_case.dart';
import 'package:servi_pro/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:servi_pro/features/requests/domain/usecases/register_use_case.dart';

class RequestNotifier extends AsyncNotifier<List<RequestEntity>> {
  StreamSubscription<List<RequestEntity>>? _requestsSubscription;

  @override
  FutureOr<List<RequestEntity>> build() async {
    final repo = ref.read(requestRepositoryProvider);
    final useCase = ref.read(getAllRequestsUseCaseProvider);
    final result = await useCase.call();
    final initial = result.fold((failure) => throw failure, (requests) => requests);

    _requestsSubscription?.cancel();
    _requestsSubscription = repo.watchAllRequests().listen(
      (requests) {
        state = AsyncValue.data(requests);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
    ref.onDispose(() {
      _requestsSubscription?.cancel();
      _requestsSubscription = null;
    });

    return initial;
  }

  Future<Failure?> registerRequest({required RequestEntity request}) async {
    final register = ref.read(registerRequestUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await register.call(request);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) async {
        // Recargar la lista de solicitudes
        await _reloadRequests();
        return null;
      },
    );
  }

  Future<Failure?> deleteRequest({required String id}) async {
    final delete = ref.read(deleteRequestUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await delete.call(id);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) async {
        await _reloadRequests();
        return null;
      },
    );
  }

  Future<void> _reloadRequests() async {
    final useCase = ref.read(getAllRequestsUseCaseProvider);
    final result = await useCase.call();

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (requests) => AsyncValue.data(requests),
    );
  }

  // Método para refrescar manualmente
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _reloadRequests();
  }
}

// Providers
final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestImpl(),
);

final getAllRequestsUseCaseProvider = Provider<GetAllRequestsUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return GetAllRequestsUseCase(repo);
});

final registerRequestUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return RegisterUseCase(repo);
});

final deleteRequestUseCaseProvider = Provider<DeletedRequestUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return DeletedRequestUseCase(repository: repo);
});

final getResquestByIdProvider = Provider<GetRequestByIdUsecase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return GetRequestByIdUsecase(repository: repo);
});

final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, List<RequestEntity>>(
      RequestNotifier.new,
    );

//provider para treaer las postulaciones por cada request
final requestPostulationsCountProvider = Provider.family<int, String>((
  ref,
  requestId,
) {
  final applications = ref.watch(workerApplicationsProvider);
  return applications.when(
    data: (data) => data.where((data) => data.idrequest == requestId).length,
    error: (error, stackTrace) {
      print("error: $error al tarea solicitudes");
      return 0;
    },
    loading: () {
      return 0;
    },
  );
});

final resquestByIdProvider = FutureProvider.family<RequestEntity, String>((
  ref,
  id,
) async {
  final usecase = ref.read(getResquestByIdProvider);
  final result = await usecase(id);
  return result.fold((failure) => throw failure, (request) => request);
});
