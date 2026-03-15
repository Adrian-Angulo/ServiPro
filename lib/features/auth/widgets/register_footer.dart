import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/providers/auth_provider.dart';

class RegisterFooter extends ConsumerWidget {
  final VoidCallback onRegister;

  const RegisterFooter({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lee acceptedTerms e isLoading directamente del provider
    final state = ref.watch(registerProvider);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: (state.acceptedTerms && !state.isLoading) ? onRegister : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primaryOverlay50,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              elevation: 0,
            ),
            child: state.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(
                    'Crear cuenta',
                    style: AppTypography.labelLarge.copyWith(color: AppColors.onPrimary, fontSize: 16),
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes una cuenta? ',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Inicia sesión',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
