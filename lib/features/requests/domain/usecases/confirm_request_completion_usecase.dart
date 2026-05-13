import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class ConfirmRequestCompletionUsecase {
  final RequestRepository repository;

  ConfirmRequestCompletionUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String requestId,
    required String clientId,
  }) async {
    return repository.confirmCompletion(
      requestId: requestId,
      clientId: clientId,
    );
  }
}
