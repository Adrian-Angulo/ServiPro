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
}

final addAppliNotifier = AsyncNotifierProvider<Addapplicationnotifier, void>(
  () => Addapplicationnotifier(),
);
