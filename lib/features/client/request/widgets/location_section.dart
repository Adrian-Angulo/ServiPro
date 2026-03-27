import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

const _zones = [
  'Centro',
  'Norte',
  'Sur',
  'Oriente',
  'Occidente',
  'Jamondino',
  'Lorenzo',
];

class LocationSection extends StatelessWidget {
  final String? selectedZone;
  final ValueChanged<String?> onZoneChanged;

  const LocationSection({
    super.key,
    required this.selectedZone,
    required this.onZoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ubicación en Pasto', style: AppTypography.titleMedium),
            Text(
              'SAN JUAN DE PASTO',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Dropdown zona
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedZone,
              hint: Text(
                'Selecciona tu zona',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey700),
              style: AppTypography.bodyMedium,
              items: _zones
                  .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                  .toList(),
              onChanged: onZoneChanged,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Mapa placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Stack(
            children: [
              // Fondo del mapa (placeholder con color)
              Container(
                height: 180,
                width: double.infinity,
                color: AppColors.backgroundMuted,
                child: const Center(
                  child: Icon(
                    Icons.map_rounded,
                    size: 64,
                    color: AppColors.backgroundSubtle,
                  ),
                ),
              ),

              // Etiqueta "TU UBICACIÓN"
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackOverlay25,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'TU UBICACIÓN',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.grey900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),

              // Pin central
              Positioned(
                bottom: 56,
                left: 0,
                right: 0,
                child: Center(
                  child: Icon(
                    Icons.location_pin,
                    color: AppColors.primary,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),

              // Botones zoom
              Positioned(
                right: AppSpacing.md,
                top: AppSpacing.md,
                child: Column(
                  children: [
                    _ZoomButton(icon: Icons.add, onTap: () {}),
                    const SizedBox(height: AppSpacing.xs),
                    _ZoomButton(icon: Icons.remove, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackOverlay10,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: AppSpacing.iconSm + 4, color: AppColors.grey900),
      ),
    );
  }
}
