import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class DeletedRequestUseCase {
  final RequestRepository repository;

  DeletedRequestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(String requestId) async {
    if (requestId.trim().isEmpty) {
      return left(const ValidationFailure(message: 'ID de solicitud inválido'));
    }

    return await repository.deleteRequest(requestId);
  }
}
