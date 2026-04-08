import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/data/repository/request_impl.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';
import 'package:servi_pro/features/requests/domain/useCase/deleted_request_use_case.dart';
import 'package:servi_pro/features/requests/domain/useCase/register_use_case.dart';

class RequestNotifier extends AsyncNotifier<List<RequestEntity>> {
  @override
  FutureOr<List<RequestEntity>> build() async {
    final result = await ref.read(requestRepositoryProvider).allRequest();

    return result.fold((failure) => throw failure, (requests) => requests);
  }

  Future<Failure?> registerRequest({required RequestEntity request}) async {
    final register = ref.read(registerRequestUseCaseProvider);

    state = const AsyncValue.loading();

    final result = await register.call(request);

    return result.fold(
      (failure) {
        // Mantener el estado actual y retornar el error
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) async {
        // Recargar la lista de solicitudes
        final requestsResult = await ref
            .read(requestRepositoryProvider)
            .allRequest();

        state = requestsResult.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (requests) => AsyncValue.data(requests),
        );

        return null; // Sin error
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
        final requestsResult = await ref
            .read(requestRepositoryProvider)
            .allRequest();

        state = requestsResult.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (requests) => AsyncValue.data(requests),
        );

        return null;
      },
    );
  }
}

// Providers
final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestImpl(),
);

final registerRequestUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return RegisterUseCase(repo);
});

final deleteRequestUseCaseProvider = Provider<DeletedRequestUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return DeletedRequestUseCase(repository: repo);
});

final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, List<RequestEntity>>(
      RequestNotifier.new,
    );
