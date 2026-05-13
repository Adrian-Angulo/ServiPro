import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';

class Addapplicationnotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> addApplication({
    required String idWorker,
    required String idRequest,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(addApliUsecaseProvider);
    final result = await usecase(idWorker: idWorker, idRequest: idRequest);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> cancelApplication({
    required String id,
    required String idRequest,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(cancelApliUsecaseProvider);
    final result = await usecase(id: id, idRequest: idRequest);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> acceptApplication({
    required String applicationId,
    required String requestId,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(acceptApliUsecaseProvider);
    final result = await usecase(
      applicationId: applicationId,
      requestId: requestId,
    );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> completeRequest({
    required String applicationId,
    required String requestId,
  }) async {
    state = const AsyncLoading();
    final usecase = ref.read(completeRequestUsecaseProvider);
    final result = await usecase(
      applicationId: applicationId,
      requestId: requestId,
    );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

final addAppliNotifier = AsyncNotifierProvider<Addapplicationnotifier, void>(
  () => Addapplicationnotifier(),
);
