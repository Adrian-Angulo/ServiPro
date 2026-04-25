import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';

abstract class IAuthDatasource {
  Future<Usuario> login({required String email, required String password});
  Future<Usuario> registerCliente({
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required Rol rol,
    required String ciudad,
  });
  Future<void> registerTrabajador({
    required String email,
    required String password,
    required String nombreCompleto,
    required int edad,
    required String ciudad,
    required String celular,
    required String cedula,
    required String sobreMi,
  });
  Future<Usuario?> getCurrentUser();
  Future<void> logout();
  Future<void> sendPasswordReset({required String email});
}
