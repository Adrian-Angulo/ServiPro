import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';

class FilterTabs extends StatelessWidget {
  final EstadoSolicitud? selected; // null = "Todos"
  final ValueChanged<EstadoSolicitud?> onSelected;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // 🔑 IMPORTANTE: altura fija para evitar problemas de layout
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // "Todos"
          _FilterChip(
            label: 'Todos',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Estados dinámicos
          ...EstadoSolicitud.values
              .where((e) => e != EstadoSolicitud.cancelada)
              .map((estado) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: _FilterChip(
                      label: _labelParaEstado(estado),
                      isSelected: selected == estado,
                      onTap: () => onSelected(estado),
                    ),
                  )),
        ],
      ),
    );
  }

  // Texto amigable para cada estado en los filtros
  String _labelParaEstado(EstadoSolicitud estado) {
    switch (estado) {
      case EstadoSolicitud.pendiente:
        return 'Pendiente';
      case EstadoSolicitud.enCurso:
        return 'En Curso';
      case EstadoSolicitud.finalizada:
        return 'Completado';
      case EstadoSolicitud.cancelada:
        return 'Cancelada';
    }
  }
}

// Chip individual de filtro
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.grey300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isSelected
                  ? AppColors.onAccent
                  : AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }
}