import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, Unit>> registerRequest(RequestEntity request);
  Future<Either<Failure, List<RequestEntity>>> allRequest();

  /// Emite la lista completa cada vez que cambia la colección `requests` en Firestore.
  Stream<List<RequestEntity>> watchAllRequests();
  Future<Either<Failure, Unit>> deleteRequest(String id);
  Future<Either<Failure, RequestEntity>> getRequestById(String id);
  Future<Either<Failure, Unit>> markAsCompleted({
    required String requestId,
    required String workerId,
  });
  Future<Either<Failure, Unit>> confirmCompletion({
    required String requestId,
    required String clientId,
  });
}
