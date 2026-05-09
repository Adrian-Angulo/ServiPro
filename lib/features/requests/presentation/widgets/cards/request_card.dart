import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/utils.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

class RequestCard extends ConsumerWidget {
  final RequestEntity requestEntity;
  final VoidCallback? onPress;

  const RequestCard({super.key, this.onPress, required this.requestEntity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = Utils.getStatusColor(requestEntity.status);
    final user = ref.watch(authNotifierProvider).value;

    if (user == null) return const SizedBox.shrink();

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
                        children: [],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Título
                      Text(
                        requestEntity.title,
                        style: AppTypography.titleLarge.copyWith(
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
                        requestEntity.details,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Botón de acción (alineado a la derecha)
                      if (onPress != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: onPress,
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
                              user.rol.name == "cliente"
                                  ? 'Cancelar Solicitud'
                                  : 'Postularme',
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
