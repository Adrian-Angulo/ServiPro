import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';

class CompleteRequestUsecase {
  final ApplicationRepository _repository;

  CompleteRequestUsecase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String applicationId,
    required String requestId,
  }) async {
    return await _repository.completeRequest(
      applicationId: applicationId,
      requestId: requestId,
    );
  }
}
