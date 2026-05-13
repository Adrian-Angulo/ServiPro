import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/application/data/datasources/application_firebase_datasource.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/domain/repositories/application_repository.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationFirebaseDatasource firebaseDatasource =
      ApplicationFirebaseDatasource();

  @override
  Future<Either<Failure, Unit>> addAplication({
    required String idWorker,
    required String idRequest,
  }) async {
    try {
      final application = ApplicationEntity(
        id: "",
        idworker: idWorker,
        idrequest: idRequest,
        state: ApplicationStatus.postulado,
      );
      await firebaseDatasource.addAplication(application);
      return Right(unit);
    } catch (e) {
      print("ocurrio un error $e");
      return Left(FirebaseFailure(message: "error $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelApplication({
    required String id,
    required String idRequest,
  }) async {
    try {
      await firebaseDatasource.cancelApplication(id, idRequest);
      return Right(unit);
    } catch (e) {
      print("ocurrio un error al cancelar $e");
      return Left(FirebaseFailure(message: "error al cancelar $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptApplication({
    required String applicationId,
    required String requestId,
  }) async {
    try {
      await firebaseDatasource.acceptApplication(applicationId, requestId);
      return Right(unit);
    } catch (e) {
      print("ocurrio un error al aceptar $e");
      return Left(FirebaseFailure(message: "error al aceptar $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeRequest({
    required String applicationId,
    required String requestId,
  }) async {
    try {
      await firebaseDatasource.completeRequest(applicationId, requestId);
      return Right(unit);
    } catch (e) {
      print("ocurrio un error al completar $e");
      return Left(FirebaseFailure(message: "error al completar $e"));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getAppliForRequest({
    required String idRequest,
  }) async {
    try {
      final applications = await firebaseDatasource.getAppliForRequest(
        idRequest,
      );
      return Right(applications);
    } catch (e) {
      return Left(
        FirebaseFailure(message: "Error al obtener postulaciones: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getAppliForWorker({
    required String idWorker,
  }) async {
    try {
      final applications = await firebaseDatasource.getAppliForWorker(idWorker);
      return Right(applications);
    } catch (e) {
      return Left(
        FirebaseFailure(message: "Error al obtener postulaciones: $e"),
      );
    }
  }
}
