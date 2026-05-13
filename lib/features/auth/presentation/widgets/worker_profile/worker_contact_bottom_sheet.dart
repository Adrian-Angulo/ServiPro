import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/communication_service.dart';

class WorkerContactBottomSheet {
  static void show(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Agarradera (Drag handle)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Elige un método de contacto',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOverlay10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'Llamar por teléfono',
                    style: AppTypography.titleSmall,
                  ),
                  subtitle: Text(phoneNumber, style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.pop(context);
                    CommunicationService.callPhone(phoneNumber);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentOverlay10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  title: Text(
                    'Enviar mensaje de WhatsApp',
                    style: AppTypography.titleSmall,
                  ),
                  subtitle: Text(phoneNumber, style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.pop(context);
                    CommunicationService.openWhatsApp(phoneNumber);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}
