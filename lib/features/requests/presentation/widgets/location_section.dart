import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/requests/presentation/screens/map_screen.dart';

class LocationSection extends StatefulWidget {
  final TextEditingController addressController;

  const LocationSection({super.key, required this.addressController});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  bool _addressHasFocus = false;
  final FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _addressFocusNode.addListener(() {
      setState(() => _addressHasFocus = _addressFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Ubicación', style: AppTypography.titleLarge)],
        ),
        const SizedBox(height: AppSpacing.lg),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.backgroundSoft,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _addressHasFocus ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextField(
            controller: widget.addressController,
            focusNode: _addressFocusNode,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Cra 24 #17-21, Barrio chapal',
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
        const SizedBox(height: AppSpacing.lg),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.backgroundMuted,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Stack(
              children: [
                MapScreen(),
                Positioned(
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: Column(
                    children: [
                      _MapControlButton(icon: Icons.add, onPressed: () {}),
                      const SizedBox(height: AppSpacing.xs),
                      _MapControlButton(icon: Icons.remove, onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(icon, color: AppColors.grey700, size: 20),
          ),
        ),
      ),
    );
  }
}
