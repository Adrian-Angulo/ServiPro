import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/category_helper.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/widgets/app_time_ago.dart';


class RequestCard extends ConsumerWidget {
  final RequestEntity requestEntity;
  final VoidCallback? onPress;

  const RequestCard({super.key, this.onPress, required this.requestEntity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    final postulation = ref.watch(workerApplicationsProvider).value ?? [];

    if (user == null) return const SizedBox.shrink();

    return Card(
      color: Colors.white,
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
                decoration: BoxDecoration(color: Color.fromRGBO(15, 23, 42, 1)),
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
                        children: [
                          CategoryHelper.getIconWithLabel(
                            requestEntity.idTypeService,
                          ),
                          AppTimeAgo(date: requestEntity.dateCreated),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        requestEntity.addres,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
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
                      const SizedBox(height: AppSpacing.xs),
                      // Descripción
                      Text(
                        requestEntity.details,
                        style: AppTypography.bodyMedium.copyWith(height: 1.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        postulation.isEmpty
                            ? "No hay postulaciones "
                            : 'Existe ${postulation.length} postulaciones',
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Botón de acción (alineado a la derecha)
                      if (onPress != null && user.rol.name == 'Trabajador')
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
                              'Postularme',
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
