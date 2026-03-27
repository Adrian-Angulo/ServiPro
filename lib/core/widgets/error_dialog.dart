import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

void showErrorDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      icon: const Icon(Icons.error_outline_rounded,
          color: AppColors.error, size: 48),
      title: Text(
        'Hubo un problema',
        style: AppTypography.titleMedium,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message ?? 'No se pudo enviar la solicitud. Verifica tu conexión e intenta de nuevo.',
        style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            minimumSize: const Size(140, 44),
          ),
          child: Text(
            'Intentar de nuevo',
            style: AppTypography.labelLarge.copyWith(color: AppColors.onPrimary),
          ),
        ),
      ],
    ),
  );
}
