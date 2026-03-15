import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/data/repositories/abstracts/auth_repository.dart';
import 'package:servi_pro/data/repositories/impl/auth_respository_impl.dart';

// Repositorio
final authRepositoryProvider = Provider<AuthRepository>(
  (_) => AuthRepositoryImpl(),
);

// Estado del login
class LoginState {
  final bool isLoading;
  final String? error;
  final bool obscurePassword;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.obscurePassword = true,
  });

  LoginState copyWith({bool? isLoading, String? error, bool? obscurePassword, bool clearError = false}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void togglePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(authRepositoryProvider);
    final success = await repo.login(email, password);
    if (!success) {
      state = state.copyWith(isLoading: false, error: 'Correo o contraseña incorrectos.');
    } else {
      state = state.copyWith(isLoading: false);
    }
    return success;
  }
}

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

// Estado del registro
class RegisterState {
  final bool isLoading;
  final String? error;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool acceptedTerms;
  final String selectedCity;

  const RegisterState({
    this.isLoading = false,
    this.error,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.acceptedTerms = false,
    this.selectedCity = 'Pasto, Nariño',
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    bool? obscurePassword,
    bool? obscureConfirm,
    bool? acceptedTerms,
    String? selectedCity,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void togglePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void toggleConfirm() =>
      state = state.copyWith(obscureConfirm: !state.obscureConfirm);

  void setTerms(bool value) => state = state.copyWith(acceptedTerms: value);

  void setCity(String city) => state = state.copyWith(selectedCity: city);

  Future<bool> register(String email, String password, String name, String confirmPassword) async {
    if (password != confirmPassword) {
      state = state.copyWith(error: 'Las contraseñas no coinciden.');
      return false;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(authRepositoryProvider);
    final success = await repo.register(email, password, name);
    if (!success) {
      state = state.copyWith(isLoading: false, error: 'No se pudo crear la cuenta. Intenta de nuevo.');
    } else {
      state = state.copyWith(isLoading: false);
    }
    return success;
  }
}

final registerProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);
