import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _authRepository;

  ResetPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> call({required String email}) async {
    return await _authRepository.resetPassword(email: email);
  }
}
