import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';

// Tarjeta que muestra la info de un trabajador que se postuló
class PostulacionCard extends StatelessWidget {
  final Postulacion postulacion;
  final VoidCallback onAceptar;

  const PostulacionCard({
    super.key,
    required this.postulacion,
    required this.onAceptar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackOverlay10,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Fila superior: avatar + info ──────────────────────────────
          Row(
            children: [
              // Avatar del trabajador
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.backgroundMuted,
                child: Icon(Icons.person, color: AppColors.grey700, size: 30),
              ),
              const SizedBox(width: AppSpacing.md),

              // Nombre, especialidad y calificación
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postulacion.nombreTrabajador,
                      style: AppTypography.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      postulacion.especialidad,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.grey500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${postulacion.calificacion}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.grey700,
                          ),
                        ),
                        Text(
                          '  (${postulacion.trabajosRealizados} trabajos)',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Botones: WhatsApp + Aceptar ───────────────────────────────
          Row(
            children: [
              // Botón WhatsApp (teal outline)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _abrirWhatsApp(context, postulacion.telefonoWhatsapp),
                  icon: const Icon(Icons.chat_rounded, size: 16),
                  label: const Text('WhatsApp'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Botón Aceptar (oscuro)
              Expanded(
                child: ElevatedButton(
                  onPressed: onAceptar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey900,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                  child: Text(
                    'Aceptar',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Muestra el número de WhatsApp en un SnackBar
  // (cuando agregues url_launcher al pubspec, puedes abrir WhatsApp directamente)
  void _abrirWhatsApp(BuildContext context, String telefono) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('WhatsApp: $telefono'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
