import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class RequestCard extends StatelessWidget {
  final String status;
  final String title;
  final String description;
  final String time;
  final VoidCallback? onCancel;

  const RequestCard({
    super.key,
    required this.status,
    required this.title,
    required this.description,
    required this.time,
    this.onCancel,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFF1E3A5F); // Azul oscuro
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

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Icons.schedule;
      case 'en progreso':
        return Icons.build;
      case 'completado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      elevation: 6,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra vertical de estado (izquierda)
              Container(
                width: 6,
                decoration: BoxDecoration(color: statusColor),
              ),

              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Estado y tiempo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Estado
                          Row(
                            children: [
                              Icon(
                                _getStatusIcon(),
                                size: 18,
                                color: statusColor,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                status.toUpperCase(),
                                style: AppTypography.labelMedium.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          // Tiempo
                          Text(
                            time,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Título
                      Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Descripción
                      Text(
                        description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Botón de cancelar (alineado a la derecha)
                      if (onCancel != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: onCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A5F),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusLg,
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancelar Solicitud',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
