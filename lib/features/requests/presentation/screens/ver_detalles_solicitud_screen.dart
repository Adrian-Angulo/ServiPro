import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/status_mapper.dart';
import 'package:servi_pro/core/utils/time_formatter.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/postulacion_card.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_description_widget.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_header_widget.dart';
import 'package:servi_pro/features/requests/presentation/widgets/detail_location_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 18,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              request.idTypeService,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.grey700,
                              ),
                            ),
                          ],
                        ),

                        // Sección postulaciones (solo vista cliente)
                        if (!isWorkerView) ...[
                          const SizedBox(height: AppSpacing.xl),
                          _PostulacionesSection(requestId: request.id!),
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
            _WorkerActionButton(
              alreadyApplied: alreadyApplied,
              isPending: isPending,
              isLoading: isLoading,
              onApply: () => _applyToRequest(context, ref),
            )
          else if (isPending)
            _ClientCancelButton(
              isLoading: isLoading,
              onCancel: () => _cancelRequest(context, ref),
            ),
        ],
      ),
    );
  }
}

class _WorkerActionButton extends StatelessWidget {
  final bool alreadyApplied;
  final bool isPending;
  final bool isLoading;
  final VoidCallback onApply;

  const _WorkerActionButton({
    required this.alreadyApplied,
    required this.isPending,
    required this.isLoading,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: alreadyApplied || !isPending || isLoading
                ? null
                : onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.grey300,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    alreadyApplied ? 'Ya te postulaste' : 'Postularme',
                    style: AppTypography.labelLarge.copyWith(
                      color: alreadyApplied ? AppColors.grey500 : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ClientCancelButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancel;

  const _ClientCancelButton({required this.isLoading, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: isLoading ? null : onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onError,
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
    );
  }
}

// Provider para obtener datos del trabajador por ID — usa el usecase de auth
// (eliminado acceso directo a Firestore)

class _PostulacionesSection extends ConsumerWidget {
  final String requestId;

  const _PostulacionesSection({required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(
      applicationsByRequestProvider(requestId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Postulaciones',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        applicationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Text(
            'Error al cargar postulaciones',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
          data: (applications) {
            if (applications.isEmpty) {
              return Text(
                'Aún no hay postulaciones para esta solicitud',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final app = applications[index];
                return _PostulacionItem(application: app);
              },
            );
          },
        ),
      ],
    );
  }
}

class _PostulacionItem extends ConsumerWidget {
  final dynamic application;

  const _PostulacionItem({required this.application});

  Future<void> _openWhatsApp(String celular) async {
    final number = celular.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/57$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerAsync = ref.watch(workerByIdProvider(application.idworker));

    return workerAsync.when(
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (worker) {
        if (worker == null) return const SizedBox.shrink();
        return PostulacionCard(
          nombreTrabajador: worker.nombreCompleto,
          especialidad: worker.sobreMi.isNotEmpty
              ? worker.sobreMi
              : 'Trabajador',
          rating: 4.9,
          trabajosRealizados: 42,
          celular: worker.celular,
          onWhatsApp: () => _openWhatsApp(worker.celular),
          onAceptar: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${worker.nombreCompleto} aceptado'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}
