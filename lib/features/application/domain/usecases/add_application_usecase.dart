import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';

class AddApplicationUsecase {
  final ApplicationRepository _repository;

  AddApplicationUsecase({required ApplicationRepository repository})
    : _repository = repository;

  Future<Either<Failure, Unit>> call({
    required String idWorker,
    required String idRequest,
  }) async {
    return _repository.addAplication(idWorker: idWorker, idRequest: idRequest);
  }
}
