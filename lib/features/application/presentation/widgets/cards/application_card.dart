import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

/// Card que muestra una postulación del trabajador con el estado y datos de la solicitud.
class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;
  final RequestEntity request;
  final VoidCallback? onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.request,
    this.onTap,
  });


  String _stateApplication(ApplicationStatus application) {
    switch (application) {
      case ApplicationStatus.aceptado:
        return "ACEPTADO";
      case ApplicationStatus.postulado:
        return "POSTULADO";
      case ApplicationStatus.noDisponible:
        return "NO DISPONIBLE";
      case ApplicationStatus.finalizado:
        return "FINALIZADO";
    }
  }

  @override
  Widget build(BuildContext context) {
    /* final stateLabel = StatusMapper.toUI(application.state);
    final color = _stateColor(application.state);
    final icon = _stateIcon(application.state); */

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
                decoration: BoxDecoration(color: Color(0xFF1E3A5F)),
              ),

              // Contenido principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Estado y tiempo
                      Text(
                        _stateApplication(application.state),
                        style: TextStyle(
                          color: Color.fromRGBO(100, 116, 139, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Título
                      Text(
                        request.title,
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      // Descripción
                      Text(
                        request.addres,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                              vertical: AppSpacing.xs,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
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
