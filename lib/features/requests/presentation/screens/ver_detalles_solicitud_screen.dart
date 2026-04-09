import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_description_widget.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_header_widget.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_location_widget.dart';

class VerDetallesSolicitudScreen extends ConsumerWidget {
  final RequestEntity request;

  const VerDetallesSolicitudScreen({super.key, required this.request});

  // Mapear estado de BD a UI
  String _mapStatusToUI(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En progreso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Pendiente';
    }
  }

  // Formatear tiempo relativo
  String _formatTimeAgo(DateTime dateCreated) {
    final now = DateTime.now();
    final difference = now.difference(dateCreated);

    if (difference.inSeconds < 60) return 'Hace un momento';
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
    }
    if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
    }
    if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
    }
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? "semana" : "semanas"}';
    }
    final months = (difference.inDays / 30).floor();
    return 'Hace $months ${months == 1 ? "mes" : "meses"}';
  }

  // Formatear fecha completa

  // Cancelar solicitud
  Future<void> _cancelRequest(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text('¿Cancelar solicitud?', style: AppTypography.titleMedium),
        content: Text(
          'Esta acción no se puede deshacer. La solicitud será eliminada permanentemente.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'No',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.grey700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sí, cancelar',
              style: AppTypography.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final failure = await ref
        .read(requestNotifierProvider.notifier)
        .deleteRequest(id: request.id!);

    if (!context.mounted) return;

    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  failure.message,
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Solicitud cancelada',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      );
      // Regresar a la pantalla anterior
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiStatus = _mapStatusToUI(request.status);
    final isPending = uiStatus == 'Pendiente';
    

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detalles de Solicitud', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Contenido con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: título, estado, tiempo
                  DetailHeaderWidget(
                    title: request.title,
                    status: uiStatus,
                    timeAgo: _formatTimeAgo(request.dateCreated),
                    date: request.dateCreated,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ubicación
                        DetailLocationWidget(
                          address: request.addres,
                          distance: '2.5 km', // Placeholder
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Placeholder para mapa (comentado para implementar después)
                        // Container(
                        //   height: 200,
                        //   decoration: BoxDecoration(
                        //     color: AppColors.grey300,
                        //     borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       'Mapa (próximamente)',
                        //       style: AppTypography.bodyMedium.copyWith(
                        //         color: AppColors.grey500,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: AppSpacing.xl),

                        // Descripción
                        DetailDescriptionWidget(description: request.details),

                        // Información adicional
                        const SizedBox(height: AppSpacing.lg),

                        // Placeholder para postulaciones (comentado para implementar después)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Postulaciones',
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.grey900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Aún no hay postulaciones para esta solicitud',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.grey900,
                              ),
                            ),
                          ],
                        ),

                        // Espacio para el botón fijo
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón fijo inferior (solo visible para solicitudes pendientes)
          if (isPending)
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackOverlay10,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _cancelRequest(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onError,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancelar Solicitud',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.onError,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.grey900,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
