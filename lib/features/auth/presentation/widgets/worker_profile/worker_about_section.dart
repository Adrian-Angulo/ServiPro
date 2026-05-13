import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_section_title.dart';

class WorkerAboutSection extends StatelessWidget {
  final String aboutText;

  const WorkerAboutSection({super.key, required this.aboutText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkerSectionTitle(title: 'Sobre mi'),
        const SizedBox(height: AppSpacing.md),
        Text(
          aboutText.isNotEmpty
              ? aboutText
              : 'El trabajador no ha agregado información adicional.',
          style: AppTypography.bodyMedium.copyWith(
            color: const Color(0xFF64748B),
            height: 1.6,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
