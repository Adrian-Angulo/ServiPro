import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/widgets/auth_widgets.dart';

class RegistroTrabajadorHeader extends StatelessWidget {
  const RegistroTrabajadorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.screenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AuthBackButton(),
              const SizedBox(width: AppSpacing.lg),
              const AuthStepIndicator(currentStep: 1, totalSteps: 2),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Crea tu perfil', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Completa tu informacion para empezar a ofrecer servicios.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}