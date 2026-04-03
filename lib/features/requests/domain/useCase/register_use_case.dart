import 'dart:io';

import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/domain/repository/request_repository.dart';

class RegisterUseCase {
  final RequestRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> call(RequestModel r) async {
    try {
      return await _repository.registerRequest(r);
    } on SocketException {
      throw Exception(
        "Sin conexión a internet. Verifica tu red e intenta de nuevo.",
      );
    } catch (e) {
      throw Exception("Error al crear la solicitud");
    }
  }
}
