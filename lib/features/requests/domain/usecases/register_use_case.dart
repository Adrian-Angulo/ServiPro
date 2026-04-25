import 'package:fpdart/fpdart.dart';
import 'package:servi_pro/core/errors/failures.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class RegisterUseCase {
  final RequestRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, Unit>> call(RequestEntity request) async {
    // Validaciones básicas
    if (request.title.trim().isEmpty) {
      return left(const ValidationFailure(message: 'El título es requerido'));
    }

    if (request.details.trim().isEmpty) {
      return left(
        const ValidationFailure(message: 'La descripción es requerida'),
      );
    }

    if (request.idTypeService.trim().isEmpty) {
      return left(
        const ValidationFailure(
          message: 'Debes seleccionar un tipo de servicio',
        ),
      );
    }

    // Llamar al repositorio
    return await _repository.registerRequest(request);
  }
}
