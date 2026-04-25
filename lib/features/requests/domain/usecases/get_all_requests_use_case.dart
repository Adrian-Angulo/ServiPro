import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class GetAllRequestsUseCase {
  final RequestRepository repository;

  GetAllRequestsUseCase(this.repository);

  Future<Either<Failure, List<RequestEntity>>> call() async {
    return await repository.allRequest();
  }

  // Método adicional para filtrar por usuario
  Future<Either<Failure, List<RequestEntity>>> getByUserId(
    String userId,
  ) async {
    final result = await repository.allRequest();

    return result.map((requests) {
      return requests.where((r) => r.idClient == userId).toList();
    });
  }
}
