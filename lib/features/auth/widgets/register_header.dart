import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Únete a la comunidad',
          style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Regístrate para encontrar servicios o trabajar en Pasto.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
        ),
      ],
    );
  }
}
