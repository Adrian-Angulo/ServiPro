import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class TitleInputField extends StatelessWidget {
  const TitleInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasFocus,
    required this.labelText,
    required this.hintText,
    this.icon = Icons.edit_note,
    this.maxLines,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasFocus;
  final String labelText;
  final String hintText;
  final IconData icon;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryOverlay10,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(labelText, style: AppTypography.labelLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: hasFocus ? AppColors.primary : AppColors.backgroundMuted,
              width: 1,
            ),
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.primaryOverlay10,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextField(
            maxLines: maxLines,
            controller: controller,
            focusNode: focusNode,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
