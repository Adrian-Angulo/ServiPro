import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/client_home.dart';
import 'package:servi_pro/features/auth/presentation/screens/worket_home.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final success = await ref
        .read(authNotifierProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        if (user.rol == Rol.cliente) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ClientHome()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WorketHome()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Correo electrónico'),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'ServiPro@correo.com',
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: AppColors.grey500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _Label('Contraseña'),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.grey500,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey500,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '¿Olvidaste tu contraseña?',
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        if (authState.hasError) ...[
          const SizedBox(height: 8),
          Text(
            authState.error.toString(),
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: authState.isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 0,
            ),
            child: authState.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Iniciar sesión',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.labelMedium);
}
