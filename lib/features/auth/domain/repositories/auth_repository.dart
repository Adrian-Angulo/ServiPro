import 'package:servi_pro/features/auth/data/models/usuario.dart';

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

  Future<void> registerTrabajador({
    required String email,
    required String password,
    required String nombreCompleto,
    required int edad,
    required String ciudad,
    required String celular,
    required String cedula,
    required String sobreMi,
    required String profesion,
  });

  Future<Usuario> login({required String email, required String password});
  Future<void> logout();
  Future<Usuario?> getCurrentUser();
  Future<Usuario?> getWorkerById({required String id});
  Future<List<Usuario>> getAllWorkers();

  /// Actualiza promedio y conteo desnormalizados en `users/{workerId}`.
  Future<void> syncWorkerRatingStats({
    required String workerId,
    required double averageRating,
    required int reviewsCount,
  });
  Future<void> sendPasswordReset({required String email});
  Stream<Usuario?> authStateChanges();
  Future<void> resetPassword({required String email});
}
