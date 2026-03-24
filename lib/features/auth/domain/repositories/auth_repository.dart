
import 'package:servi_pro/data/models/usuario.dart';


abstract class AuthRepository {
  
  Future<void> registerCliente({
    required String id,
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required Rol rol,
    required String ciudad,
  });

  Future<Usuario> login({required String email, required String password});
  Future<void> logout();
  Future<Usuario?> getCurrentUser();
}
