import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/domain/entites/application_entity.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, Unit>> addAplication({
    required String idWorker,
    required String idRequest,
  });

  Future<Either<Failure, List<ApplicationEntity>>> getAppliForRequest({
    required String idRequest,
  });

  Future<Either<Failure, List<ApplicationEntity>>> getAppliForWorker({
    required String idWorker,
  });

  Future<Either<Failure, Unit>> cancelApplication({required String id});
}
