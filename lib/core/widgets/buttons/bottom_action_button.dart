import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

/// Botón flotante fijo en la parte inferior de una pantalla de detalle.
class BottomActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color disabledColor;
  final IconData? icon;

  const BottomActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.disabledColor = AppColors.grey300,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null && !isLoading;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.md,
      ),
      child: SafeArea(
        child: Material(
          elevation: 6,
          shadowColor: backgroundColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Ink(
              decoration: BoxDecoration(
                color: isDisabled ? disabledColor : backgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        colors: [
                          backgroundColor,
                          backgroundColor.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  else ...[
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: isDisabled ? AppColors.grey500 : textColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: AppTypography.labelLarge.copyWith(
                        color: isDisabled ? AppColors.grey500 : textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
