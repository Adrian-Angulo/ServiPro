import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class MarkRequestCompletedUsecase {
  final RequestRepository repository;

  MarkRequestCompletedUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String requestId,
    required String workerId,
  }) async {
    return repository.markAsCompleted(requestId: requestId, workerId: workerId);
  }
}
