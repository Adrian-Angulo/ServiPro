import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:servi_pro/data/models/usuario.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  AuthNotifier(this._repository);
  Usuario? user;
  bool isLoading = false;
  String? error;



  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await _repository.login(email: email, password: password);
    } catch (e) {
      error = _parseError(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerClient({
    required String id,
    required String email,
    required String password,
    required String nombre,
    required String edad,
    required String telefono,
    required String cedula,
    required Rol rol,
    required String ciudad,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _repository.registerCliente(
        id: id,
        email: email,
        password: password,
        nombre: nombre,
        edad: edad,
        telefono: telefono,
        cedula: cedula,
        rol: rol,
        ciudad: ciudad,
      );
    } catch (e) {
      error = _parseError(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    user = null;
    notifyListeners();
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
    return 'Ocurrió un error. Intenta de nuevo';
  }
}
