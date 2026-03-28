import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';
import 'package:servi_pro/features/client/my_requests/widgets/postulacion_card.dart';

// Pantalla de detalle de una solicitud específica
class SolicitudDetailScreen extends StatelessWidget {
  final Solicitud solicitud;

  const SolicitudDetailScreen({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: Column(
        children: [
          // ── Contenido scrolleable ────────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              slivers: [
                // AppBar con título y fecha
                SliverAppBar(
                  backgroundColor: AppColors.backgroundSoft,
                  elevation: 0,
                  floating: true,
                  snap: true,
                  leading: const BackButton(color: AppColors.grey900),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Título de la solicitud (puede ser largo)
                      Expanded(
                        child: Text(
                          solicitud.titulo,
                          style: AppTypography.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Fecha de publicación
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Publicado',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                          Text(
                            _tiempoTranscurrido(solicitud.fechaCreacion),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                    vertical: AppSpacing.screenVertical,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Ubicación ──────────────────────────────────────
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                solicitud.barrio.isNotEmpty
                                    ? solicitud.barrio
                                    : solicitud.zona,
                                style: AppTypography.titleSmall,
                              ),
                              Text(
                                'A 0.8 km de tu ubicación actual',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Mapa placeholder ───────────────────────────────
                      _MapaPlaceholder(),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Descripción ────────────────────────────────────
                      Text(
                        'Descripción del problema',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        solicitud.descripcion,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Postulaciones (solo si hay) ────────────────────
                      if (solicitud.postulaciones.isNotEmpty) ...[
                        Text(
                          'Postulaciones',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...solicitud.postulaciones.map(
                          (p) => PostulacionCard(
                            postulacion: p,
                            onAceptar: () =>
                                _confirmarAceptar(context, p.nombreTrabajador),
                          ),
                        ),
                      ],

                      // Espacio al final para que el botón no tape contenido
                      const SizedBox(height: AppSpacing.xxxl),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Botón fijo en la parte inferior ─────────────────────────────
          _BotonCancelar(
            onCancelar: () => _confirmarCancelacion(context),
          ),
        ],
      ),
    );
  }

  // Diálogo para confirmar que se acepta un trabajador
  void _confirmarAceptar(BuildContext context, String nombre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Aceptar trabajador', style: AppTypography.titleMedium),
        content: Text(
          '¿Deseas aceptar a $nombre para este trabajo?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.grey700)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: guardar en Firebase que este trabajador fue aceptado
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$nombre aceptado'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: Text('Aceptar',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.onPrimary)),
          ),
        ],
      ),
    );
  }

  // Diálogo para confirmar cancelación de la solicitud
  void _confirmarCancelacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancelar solicitud', style: AppTypography.titleMedium),
        content: Text(
          '¿Estás seguro de que quieres cancelar esta solicitud?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No, volver',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.grey700)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Regresa a la lista
              // TODO: actualizar estado en Firebase
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: Text('Sí, cancelar',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.onError)),
          ),
        ],
      ),
    );
  }

  String _tiempoTranscurrido(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);
    if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours} horas';
    return 'Hace ${diferencia.inDays} días';
  }
}

// ── Mapa placeholder ──────────────────────────────────────────────────────────
class _MapaPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Stack(
        children: [
          // Fondo del mapa
          Container(
            height: 160,
            width: double.infinity,
            color: AppColors.backgroundMuted,
            child: const Center(
              child: Icon(Icons.map_rounded,
                  size: 56, color: AppColors.backgroundSubtle),
            ),
          ),
          // Pin de ubicación
          const Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(Icons.location_pin,
                  color: AppColors.accent, size: AppSpacing.iconLg),
            ),
          ),
          // Botón "Ver mapa completo"
          Positioned(
            bottom: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackOverlay10,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Ver mapa completo',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.grey900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de cancelar fijo abajo ──────────────────────────────────────────────
class _BotonCancelar extends StatelessWidget {
  final VoidCallback onCancelar;

  const _BotonCancelar({required this.onCancelar});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundSoft,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.xl,
      ),
      child: ElevatedButton(
        onPressed: onCancelar,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
        ),
        child: Text(
          'Cancelar Solicitud',
          style: AppTypography.labelLarge.copyWith(color: AppColors.onAccent),
        ),
      ),
    );
  }
}
