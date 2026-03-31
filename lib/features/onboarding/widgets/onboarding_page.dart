import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class OnboardingData {
  final String title;
  final String titleHighlight;
  final String description;
  final String descriptionLink;
  final String descriptionEnd;
  final IconData badge1Icon;
  final String badge1Label;
  final IconData badge2Icon;
  final String badge2Label;

  const OnboardingData({
    required this.title,
    required this.titleHighlight,
    required this.description,
    required this.descriptionLink,
    required this.descriptionEnd,
    required this.badge1Icon,
    required this.badge1Label,
    required this.badge2Icon,
    required this.badge2Label,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', height: 90),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
              children: [
                const TextSpan(text: 'Servi'),
                const TextSpan(
                  text: 'Pro',
                  style: TextStyle(color: AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(height: 1.3),
          ),
          Text(
            data.titleHighlight,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          if (data.descriptionLink.isEmpty)
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey700,
              ),
            )
          else
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
                children: [
                  TextSpan(text: data.description),
                  TextSpan(
                    text: data.descriptionLink,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.accent,
                    ),
                  ),
                  TextSpan(text: data.descriptionEnd),
                ],
              ),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Badge(icon: data.badge1Icon, label: data.badge1Label),
              const SizedBox(width: 16),
              _Badge(
                icon: data.badge2Icon,
                label: data.badge2Label,
                iconColor: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _Badge({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay10,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: AppColors.grey900),
          ),
        ],
      ),
    );
  }
}
