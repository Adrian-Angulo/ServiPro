import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

/// Widget que muestra un resumen de estadísticas del trabajador
class WorkerStatsSummaryWidget extends StatelessWidget {
  final int completedJobs;
  final double rating;
  final int totalReviews;

  const WorkerStatsSummaryWidget({
    super.key,
    required this.completedJobs,
    required this.rating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.check_circle_outline,
            value: completedJobs.toString(),
            label: 'Trabajos\nCompletados',
          ),
          _StatItem(
            icon: Icons.star_rate_rounded,
            value: rating.toStringAsFixed(1),
            label: 'Calificación\nPromedio',
          ),
          _StatItem(
            icon: Icons.rate_review_outlined,
            value: totalReviews.toString(),
            label: 'Reseñas\nRecibidas',
          ),
        ],
      ),
    );
  }
}

/// Widget privado que muestra una estadística individual
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: Colors.grey[600],
            letterSpacing: 0.15,
          ),
        ),
      ],
    );
  }
}
