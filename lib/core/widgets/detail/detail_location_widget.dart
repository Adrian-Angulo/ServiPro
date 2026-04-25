import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

/// Widget para mostrar la ubicación con icono, dirección y distancia placeholder
class DetailLocationWidget extends StatelessWidget {
  final String address;
  final String? distance;

  const DetailLocationWidget({super.key, required this.address, this.distance});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(Icons.location_on, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xs),
              Text(
                address,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              if (distance != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      "A",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      distance!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      "de tu ubicicacion",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
