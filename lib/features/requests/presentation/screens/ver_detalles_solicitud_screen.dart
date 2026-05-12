import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/category_helper.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/core/utils/time_formatter.dart';
import 'package:servi_pro/core/widgets/badge/status_badge.dart';
import 'package:servi_pro/core/widgets/buttons/bottom_action_button.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/postulaciones_section.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';

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

    if (!context.mounted) return;
    final result = ref.watch(addAppliNotifier);

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
    final uiStatus = request.status;
    final isPending = uiStatus == ServiceStatus.pending;
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: request.status),
                CategoryHelper.getIconWithLabel(request.idTypeService),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(request.title, style: AppTypography.titleLarge),
            SizedBox(height: AppSpacing.xl),
            Row(
              spacing: AppSpacing.md,
              children: [
                ServiceDateItem(
                  color: Colors.green,
                  date: request.dateCreated,
                  icon: Icons.calendar_month_outlined,
                  title: 'Publicado',
                ),

                if (!isWorkerView) ...[
                  Container(width: 1, height: 40, color: AppColors.grey500),
                  ServiceDateItem(
                    color: Colors.amber,
                    date: request.dateCreated,
                    icon: Icons.person,
                    title: 'Asignado',
                  ),
                  Container(width: 1, height: 40, color: AppColors.grey500),
                  ServiceDateItem(
                    color: Colors.blue,
                    date: request.dateCreated,
                    icon: Icons.check_circle_outline_outlined,
                    title: 'Finalizado',
                  ),
                ],
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey500.withOpacity(0.5),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Descripción del problema",
                          style: AppTypography.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          request.details,
                          style: AppTypography.bodyMedium,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey500.withOpacity(0.5),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dirección", style: AppTypography.labelLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          request.addres,
                          style: AppTypography.bodyMedium,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          maxLines: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isWorkerView) ...[
                      const SizedBox(height: AppSpacing.xl),
                      PostulacionesSection(requestId: request.id!),
                    ],
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
      ),
    );
  }
}

class ServiceDateItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final DateTime date;

  const ServiceDateItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              Text(
                TimeFormatter.shortDate(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
