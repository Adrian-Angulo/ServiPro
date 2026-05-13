import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';

class CancelApplicationUsecase {
  final ApplicationRepository repository;

  CancelApplicationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String id,
    required String idRequest,
  }) async {
    return await repository.cancelApplication(id: id, idRequest: idRequest);
  }
}
