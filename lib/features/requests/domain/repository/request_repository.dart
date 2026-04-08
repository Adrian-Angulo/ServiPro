import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  Future<Either<Failure, List<RequestEntity>>> allRequest();
  Future<Either<Failure, Unit>> deleteRequest(String id);
}
