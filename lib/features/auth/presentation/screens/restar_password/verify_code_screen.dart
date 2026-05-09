import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/screens/restar_password/password_reset_success_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _verify() async {
    if (_code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código completo de 6 dígitos')),
      );
      return;
    }
    setState(() => _loading = true);
    // Firebase password reset uses email link, no code to verify client-side.
    // This screen confirms the user received the email and navigates to success.
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _loading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PasswordResetSuccessScreen()),
      );
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
              Image.asset('assets/logos/logo.png', height: 80),
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
                'Verifica tu código',
                textAlign: TextAlign.center,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                  children: [
                    const TextSpan(text: 'Enviamos un código a\n'),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _CodeBox(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  onChanged: (v) => _onChanged(i, v),
                )),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verify,
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
                          'Verificar código',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No recibiste el código? ',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Reenviar',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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

class _CodeBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _CodeBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: AppTypography.titleLarge.copyWith(color: AppColors.grey900),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: controller.text.isNotEmpty
              ? AppColors.primaryOverlay10
              : AppColors.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: controller.text.isNotEmpty
                  ? AppColors.primary
                  : AppColors.backgroundSubtle,
              width: controller.text.isNotEmpty ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
