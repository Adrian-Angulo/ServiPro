import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';

class WorkerCard extends StatelessWidget {
  final Trabajador trabajador;
  final VoidCallback? onTap;
 

  const WorkerCard({
    super.key,
    required this.trabajador,
    this.onTap,
   
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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar, Nombre y Botón de Mensaje
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar circular con iniciales
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(49, 155, 148, 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color.fromRGBO(49, 155, 148, 0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(trabajador.nombreCompleto),
                            style: GoogleFonts.nunito(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.15,
                              color: const Color.fromRGBO(49, 155, 148, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),

                  // Nombre y Ocupación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trabajador.nombreCompleto,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.15,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
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
                        // Ubicación
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Color.fromARGB(255, 130, 130, 130),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              trabajador.ciudad,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                letterSpacing: 0.15,
                                color: const Color.fromARGB(255, 130, 130, 130),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Valoración
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rate_rounded,
                            size: 20,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trabajador.reviewsCount > 0
                                ? trabajador.averageRating.toStringAsFixed(1)
                                : '—',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trabajador.reviewsCount == 1
                            ? '(1 reseña)'
                            : '(${trabajador.reviewsCount} reseñas)',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 130, 130, 130),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Estadísticas: Servicios, Satisfacción, Valoración
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Servicios completados
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              size: 18,
                              color: Color.fromARGB(255, 130, 130, 130),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '128 servicios',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'completados',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 130, 130, 130),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
