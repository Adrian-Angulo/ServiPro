import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Usuario> call(String email, String password) async {
    return await repository.login(email: email, password: password);
  }
}
