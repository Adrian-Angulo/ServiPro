import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class JobDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const JobDescriptionField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción breve',
            style: AppTypography.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: TextField(
              controller: controller,
              maxLines: 4,
              onChanged: onChanged,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    'Ej: Tengo una fuga en el grifo de la cocina\nque necesita reparación inmediata...',
                hintStyle:
                    AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                contentPadding: const EdgeInsets.all(AppSpacing.lg),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
