import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';

class AuthNotifier extends AsyncNotifier<Usuario?> {
  @override
  Future<Usuario?> build() async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.getCurrentUser();
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.login(email: email, password: password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(_parseError(e.toString()), stack);
      return false;
    }
  }

  Future<bool> registerCliente({
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required String ciudad,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.registerCliente(
        id: '',
        email: email,
        password: password,
        nombre: nombre,
        edad: edad,
        telefono: telefono,
        cedula: cedula,
        rol: Rol.cliente,
        ciudad: ciudad,
      );

      final user = await repository.getCurrentUser();
      state = AsyncValue.data(user);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(_parseError(e.toString()), stack);
      return false;
    }
  }

  Future<bool> registerTrabajador({
    required String email,
    required String password,
    required String nombreCompleto,
    required int edad,
    required String ciudad,
    required String celular,
    required String cedula,
    required String sobreMi,
    required String profesion,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.registerTrabajador(
        email: email,
        password: password,
        nombreCompleto: nombreCompleto,
        edad: edad,
        ciudad: ciudad,
        celular: celular,
        cedula: cedula,
        sobreMi: sobreMi,
        profesion: profesion,
      );

      final user = await repository.getCurrentUser();
      state = AsyncValue.data(user);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(_parseError(e.toString()), stack);
      return false;
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> sendPasswordReset({required String email}) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.sendPasswordReset(email: email);
  }

  String _parseError(String error) {
    if (error.contains('user-not-found')) {
      return 'No existe una cuenta con ese correo';
    }
    if (error.contains('wrong-password') ||
        error.contains('invalid-credential')) {
      return 'Correo o contraseña incorrectos';
    }
    if (error.contains('too-many-requests')) {
      return 'Demasiados intentos. Espera unos minutos';
    }
    if (error.contains('network-request-failed')) {
      return 'Sin conexión a internet';
    }
    if (error.contains('email-already-in-use')) {
      return 'Este correo ya está registrado';
    }
    if (error.contains('weak-password')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (error.contains('invalid-email')) {
      return 'Correo electrónico inválido';
    }
    return 'Ocurrió un error. Intenta de nuevo';
  }
}
