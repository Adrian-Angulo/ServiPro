import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/data/repository/request_impl.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';
import 'package:servi_pro/features/requests/domain/useCase/deleted_request_use_case.dart';
import 'package:servi_pro/features/requests/domain/useCase/register_use_case.dart';

class RequestNotifier extends AsyncNotifier<List<RequestModel>> {
  @override
  FutureOr<List<RequestModel>> build() async {
    return await ref.read(requestRepositoryProvider).allRequest();
  }

  Future<void> registerRequest({required RequestModel r}) async {
    final register = ref.read(registerRequestProverder);
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await register.call(r);
      return await ref.read(requestRepositoryProvider).allRequest();
    });
  }

  Future<void> deleteRquest({required String id}) async {
    final delete = ref.read(deleteRequestProvider);
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await delete.call(id);
      return await ref.read(requestRepositoryProvider).allRequest();
    });
  }
}

final requestRepositoryProvider = Provider<RequestRepository>(
  (ref) => RequestImpl(),
);

final registerRequestProverder = Provider<RegisterUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return RegisterUseCase(repo);
});

final requestNotifierProvider =
    AsyncNotifierProvider<RequestNotifier, List<RequestModel>>(
      RequestNotifier.new,
    );

final deleteRequestProvider = Provider<DeletedRequestUseCase>((ref) {
  final repo = ref.read(requestRepositoryProvider);
  return DeletedRequestUseCase(repository: repo);
});
