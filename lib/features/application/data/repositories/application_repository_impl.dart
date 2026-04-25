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
        state: "pending",
      );
      await firebaseDatasource.addAplication(application);
      return Right(unit);
    } catch (e) {
      return Left(FirebaseFailure(message: "error $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelApplication({required String id}) {
    // TODO: implement cancelApplication
    throw UnimplementedError();
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
