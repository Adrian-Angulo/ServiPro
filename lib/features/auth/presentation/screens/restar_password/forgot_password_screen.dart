import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/restar_password/password_reset_success_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/restar_password/verify_code_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo electrónico')),
      );
      return;
    }

    setState(() => _loading = true);
    // Simulado — conectar a Firebase después de verificar UI
    await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordReset(email: email);
    if (mounted) {
      setState(() => _loading = false);
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => PasswordResetSuccessScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  children: const [
                    TextSpan(text: 'Servi'),
                    TextSpan(
                      text: 'Pro',
                      style: TextStyle(color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '¿Olvidaste tu\ncontraseña?',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Introduce tu correo para recibir el código\npara restablecer tu contraseña',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Correo electrónico',
                  style: AppTypography.labelMedium,
                ),
              ),
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Enviar código',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: AppColors.grey700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Volver al inicio de sesión',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
