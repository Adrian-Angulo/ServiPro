import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class EmptyRequestsWidget extends StatelessWidget {
  final String filterType;
  final VoidCallback? onCreateRequest;

  const EmptyRequestsWidget({
    super.key,
    required this.filterType,
    this.onCreateRequest,
  });

  String _getMessage() {
    switch (filterType.toLowerCase()) {
      case 'pendiente':
        return 'No tienes solicitudes pendientes';
      case 'en progreso':
        return 'No tienes solicitudes en progreso';
      case 'completado':
        return 'No tienes solicitudes completadas';
      case 'cancelado':
        return 'No tienes solicitudes canceladas';
      default:
        return 'No tienes solicitudes aún';
    }
  }

  String _getSubMessage() {
    if (filterType.toLowerCase() == 'todos') {
      return 'Crea tu primera solicitud de servicio';
    }
    return 'Cambia el filtro para ver otras solicitudes';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.primaryOverlay10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                filterType.toLowerCase() == 'todos'
                    ? Icons.inbox_outlined
                    : Icons.filter_list_off,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              _getMessage(),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _getSubMessage(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
            if (filterType.toLowerCase() == 'todos' &&
                onCreateRequest != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onCreateRequest,
                icon: const Icon(Icons.add),
                label: const Text('Crear Solicitud'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
