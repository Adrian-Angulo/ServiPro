import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class GetAllRequestsUseCase {
  final RequestRepository _repository;

  GetAllRequestsUseCase(this._repository);

  Future<Either<Failure, List<RequestEntity>>> call() async {
    return await _repository.allRequest();
  }

  /// Obtener solicitudes filtradas por usuario
  Future<Either<Failure, List<RequestEntity>>> getByUserId(
    String userId,
  ) async {
    if (userId.trim().isEmpty) {
      return left(const ValidationFailure(message: 'ID de usuario inválido'));
    }

    final result = await _repository.allRequest();

    return result.fold((failure) => left(failure), (requests) {
      final filtered = requests
          .where((request) => request.idClient == userId)
          .toList();

      // Ordenar por fecha (más recientes primero)
      filtered.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

      return right(filtered);
    });
  }
}
