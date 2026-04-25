import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';

class GetApplicationsForWorkerUsecase {
  final ApplicationRepository _repository;

  GetApplicationsForWorkerUsecase({required ApplicationRepository repository})
    : _repository = repository;

  Future<Either<Failure, List<ApplicationEntity>>> call({
    required String idWorker,
  }) async {
    return _repository.getAppliForWorker(idWorker: idWorker);
  }
}
