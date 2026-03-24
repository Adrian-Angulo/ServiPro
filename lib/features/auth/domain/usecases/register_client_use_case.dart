import 'package:servi_pro/data/models/usuario.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class RegisterClientUseCase {
  final AuthRepository repository;

  RegisterClientUseCase(this.repository);

  Future<void> call(
    {required String id,
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required Rol rol,
    required String ciudad}
  ) async {
    return await repository.registerCliente(email: email, password: password, id: id, nombre: nombre, edad: edad, telefono: telefono, cedula: cedula, rol: rol, ciudad: ciudad);
  }
}
