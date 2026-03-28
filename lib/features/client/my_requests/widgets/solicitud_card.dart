import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';
import 'package:servi_pro/features/client/my_requests/presentation/screens/solicitud_detail_screen.dart';

// Tarjeta que muestra el resumen de una solicitud
class SolicitudCard extends StatelessWidget {
  final Solicitud solicitud;
  final VoidCallback? onCancelar;

  const SolicitudCard({
    super.key,
    required this.solicitud,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final colorBorde = _colorPorEstado(solicitud.estado);

    return GestureDetector(
      // Al tocar la tarjeta, abre el detalle
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SolicitudDetailScreen(solicitud: solicitud),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border(left: BorderSide(color: colorBorde, width: 4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackOverlay10,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: estado + tiempo transcurrido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _EstadoBadge(estado: solicitud.estado),
                  Text(
                    _tiempoTranscurrido(solicitud.fechaCreacion),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Título
              Text(solicitud.titulo, style: AppTypography.titleSmall),
              const SizedBox(height: AppSpacing.xs),

              // Descripción corta
              Text(
                solicitud.descripcion,
                style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Botón cancelar (solo si está pendiente)
              if (solicitud.estado == EstadoSolicitud.pendiente &&
                  onCancelar != null) ...[
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onCancelar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey900,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                    child: Text(
                      'Cancelar Solicitud',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _colorPorEstado(EstadoSolicitud estado) {
    switch (estado) {
      case EstadoSolicitud.finalizada:
        return Colors.green;
      case EstadoSolicitud.enCurso:
        return AppColors.accent;
      case EstadoSolicitud.pendiente:
        return AppColors.primary;
      case EstadoSolicitud.cancelada:
        return AppColors.grey500;
    }
  }

  String _tiempoTranscurrido(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);
    if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours} horas';
    return 'Hace ${diferencia.inDays} días';
  }
}

// Badge pequeño que muestra el estado con ícono y color
class _EstadoBadge extends StatelessWidget {
  final EstadoSolicitud estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final color = _colorPorEstado(estado);
    final icono = _iconoPorEstado(estado);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          estado.nombre,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Color _colorPorEstado(EstadoSolicitud estado) {
    switch (estado) {
      case EstadoSolicitud.finalizada:
        return Colors.green;
      case EstadoSolicitud.enCurso:
        return AppColors.accent;
      case EstadoSolicitud.pendiente:
        return AppColors.primary;
      case EstadoSolicitud.cancelada:
        return AppColors.grey500;
    }
  }

  IconData _iconoPorEstado(EstadoSolicitud estado) {
    switch (estado) {
      case EstadoSolicitud.finalizada:
        return Icons.check_circle_outline_rounded;
      case EstadoSolicitud.enCurso:
        return Icons.timelapse_rounded;
      case EstadoSolicitud.pendiente:
        return Icons.calendar_today_rounded;
      case EstadoSolicitud.cancelada:
        return Icons.cancel_outlined;
    }
  }
}
