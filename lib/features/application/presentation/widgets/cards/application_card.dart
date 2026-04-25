import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/status_mapper.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

/// Card que muestra una postulación del trabajador con el estado y datos de la solicitud.
class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;
  final RequestEntity? request;
  final VoidCallback? onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    this.request,
    this.onTap,
  });

  Color _stateColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return const Color(0xFF1E3A5F);
      case 'in_progress':
        return AppColors.accent;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.grey500;
      default:
        return const Color(0xFF1E3A5F);
    }
  }

  IconData _stateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'in_progress':
        return Icons.build;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateLabel = StatusMapper.toUI(application.state);
    final color = _stateColor(application.state);
    final icon = _stateIcon(application.state);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(icon, size: 18, color: color),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                stateLabel.toUpperCase(),
                                style: AppTypography.labelMedium.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOverlay10,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull,
                              ),
                            ),
                            child: Text(
                              'Postulación',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        request?.title ??
                            'Solicitud #${application.idrequest.substring(0, 6)}',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (request != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          request!.details,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                request!.addres,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.grey500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
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
