import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class ActionButtons extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onPublish;
  final bool isEnabled;

  const ActionButtons({
    super.key,
    required this.onCancel,
    required this.onPublish,
    this.isEnabled = true,
  });

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: Text(
              'Cancelar',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: widget.isEnabled ? widget.onPublish : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.grey300,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              elevation: widget.isEnabled ? 4 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: Text(
              'Publicar solicitud',
              style: AppTypography.labelLarge.copyWith(
                color: widget.isEnabled
                    ? AppColors.onAccent
                    : AppColors.grey500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
