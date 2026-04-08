import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

/// Widget para el header de detalles: título, badge de estado y tiempo relativo
class DetailHeaderWidget extends StatelessWidget {
  final String title;
  final String status;
  final String timeAgo;
  final DateTime date;

  const DetailHeaderWidget({
    super.key,
    required this.title,
    required this.status,
    required this.timeAgo,
    required this.date,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFF1E3A5F);
      case 'en progreso':
        return AppColors.accent;
      case 'completado':
        return AppColors.primary;
      case 'cancelado':
        return AppColors.grey500;
      default:
        return const Color(0xFF1E3A5F);
    }
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day de $month de $year a las $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.grey300, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de estado
          Container(
            child: Text(
              status.toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Título
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.grey900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Tiempo relativo
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.grey700),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    timeAgo,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildInfoRow('Fecha de creación', _formatFullDate(date)),
        ],
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
      ),
      Flexible(
        child: Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
