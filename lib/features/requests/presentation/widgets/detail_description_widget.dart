import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

/// Widget para mostrar la descripción completa con título de sección
class DetailDescriptionWidget extends StatelessWidget {
  final String description;

  const DetailDescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción del servicio',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.grey900,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
