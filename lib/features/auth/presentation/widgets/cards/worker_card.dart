import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';

class WorkerCard extends StatelessWidget {
  final Trabajador trabajador;
  final VoidCallback? onTap;
  final VoidCallback? onMessageTap;

  const WorkerCard({
    super.key,
    required this.trabajador,
    this.onTap,
    this.onMessageTap,
  });

  /// Obtiene las iniciales del nombre del trabajador
  String _getInitials(String nombre) {
    final parts = nombre.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return nombre.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Avatar con iniciales
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(49, 155, 148, 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  _getInitials(trabajador.nombreCompleto),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.15,
                    color: AppColors.surface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Información del trabajador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      trabajador.nombreCompleto,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.15,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Ocupación
                    Text(
                      'Profesional de servicios',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        letterSpacing: 0.15,
                        color: const Color.fromARGB(255, 130, 130, 130),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Ubicación y Valoración
                    Row(
                      children: [
                        // Ubicación
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Color.fromARGB(255, 130, 130, 130),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  trabajador.ciudad,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    letterSpacing: 0.15,
                                    color: const Color.fromARGB(
                                      255,
                                      130,
                                      130,
                                      130,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),

                        // Valoración
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.15,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Botón de mensaje
              GestureDetector(
                onTap: onMessageTap,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(158, 158, 158, 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.messenger,
                    color: Color.fromARGB(255, 20, 142, 243),
                    size: 20,
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
