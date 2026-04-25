import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/status_mapper.dart';
import 'package:servi_pro/core/utils/time_formatter.dart';
import 'package:servi_pro/core/widgets/buttons/bottom_action_button.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/postulaciones_section.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/core/widgets/detail/detail_description_widget.dart';
import 'package:servi_pro/core/widgets/detail/detail_header_widget.dart';
import 'package:servi_pro/core/widgets/detail/detail_location_widget.dart';

class VerDetallesSolicitudScreen extends ConsumerWidget {
  final RequestEntity request;
  final bool isWorkerView;
  final bool alreadyApplied;

  const VerDetallesSolicitudScreen({
    super.key,
    required this.request,
    this.isWorkerView = false,
    this.alreadyApplied = false,
  });

  String _mapStatusToUI(String status) => StatusMapper.toUI(status);
  String _formatTimeAgo(DateTime dateCreated) =>
      TimeFormatter.timeAgo(dateCreated);

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
          content: Text(failure.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Solicitud cancelada'),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _applyToRequest(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    await ref
        .read(addAppliNotifier.notifier)
        .addApplication(idWorker: user.id, idRequest: request.id!);

    final result = ref.read(addAppliNotifier);
    if (!context.mounted) return;

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al postularse. Intenta de nuevo.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Recargar postulaciones para actualizar el filtro
      await ref.read(workerApplicationsProvider.notifier).load(user.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('¡Postulación enviada!'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiStatus = _mapStatusToUI(request.status);
    final isPending = uiStatus == 'Pendiente';
    final postulationState = ref.watch(addAppliNotifier);
    final isLoading = postulationState is AsyncLoading;

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailHeaderWidget(
                    title: request.title,
                    status: uiStatus,
                    timeAgo: _formatTimeAgo(request.dateCreated),
                    date: request.dateCreated,
                    typeService: request.idTypeService,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailLocationWidget(
                          address: request.addres,
                          distance: '2.5 km',
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        DetailDescriptionWidget(description: request.details),
                        const SizedBox(height: AppSpacing.lg),

                        // Categoría

                        // Sección postulaciones (solo vista cliente)
                        if (!isWorkerView) ...[
                          const SizedBox(height: AppSpacing.xl),
                          PostulacionesSection(requestId: request.id!),
                        ],

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón inferior — varía según el rol
          if (isWorkerView)
            BottomActionButton(
              label: alreadyApplied ? 'Ya te postulaste' : 'Postularme',
              onPressed: alreadyApplied || !isPending
                  ? null
                  : () => _applyToRequest(context, ref),
              isLoading: isLoading,
              backgroundColor: AppColors.primary,
            )
          else if (isPending)
            BottomActionButton(
              label: 'Cancelar Solicitud',
              onPressed: () => _cancelRequest(context, ref),
              isLoading: isLoading,
              backgroundColor: AppColors.accent,
            ),
        ],
      ),
    );
  }
}
