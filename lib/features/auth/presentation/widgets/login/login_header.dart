import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/logo.png', height: 90),
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
        const SizedBox(height: 32),
        Text(
          '¡Hola de nuevo!',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingresa a tu cuenta para encontrar expertos en Pasto.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
        ),
      ],
    );
  }
}
