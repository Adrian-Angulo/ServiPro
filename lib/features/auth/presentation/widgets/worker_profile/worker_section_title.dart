import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class WorkerSectionTitle extends StatelessWidget {
  final String title;
  final bool showRightSpace;

  const WorkerSectionTitle({
    super.key,
    required this.title,
    this.showRightSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: showRightSpace ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
