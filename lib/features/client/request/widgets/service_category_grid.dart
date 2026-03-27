import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class _Category {
  final String label;
  final IconData icon;
  const _Category(this.label, this.icon);
}

const _categories = [
  _Category('Plomería', Icons.plumbing_rounded),
  _Category('Electricidad', Icons.bolt_rounded),
  _Category('Carpintería', Icons.carpenter_rounded),
  _Category('Limpieza', Icons.cleaning_services_rounded),
  _Category('Pintura', Icons.format_paint_rounded),
  _Category('Otros', Icons.more_horiz_rounded),
];

class ServiceCategoryGrid extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const ServiceCategoryGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.0,
      children: _categories.map((cat) {
        final isSelected = selected == cat.label;
        return GestureDetector(
          onTap: () => onSelected(cat.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryOverlay10 : AppColors.backgroundMuted,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.grey100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    cat.icon,
                    color: isSelected ? AppColors.onPrimary : AppColors.grey700,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  cat.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.grey700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
