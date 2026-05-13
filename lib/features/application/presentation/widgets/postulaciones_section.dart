import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/cards/postulacion_card.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/core/utils/communication_service.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

/// Sección que muestra las postulaciones de una solicitud (vista cliente).
class PostulacionesSection extends ConsumerWidget {
  final RequestEntity request;

  const PostulacionesSection({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(
      applicationsByRequestProvider(request.id!),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (request.status == ServiceStatus.inProgress || request.status == ServiceStatus.completed)
              ? 'Trabajador del Servicio' 
              : 'Postulaciones',
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
          data: (allApplications) {
            final applications = allApplications.where((a) {
              if (request.status == ServiceStatus.inProgress) {
                return a.state == ApplicationStatus.aceptado;
              } else if (request.status == ServiceStatus.completed) {
                return a.state == ApplicationStatus.finalizado || a.state == ApplicationStatus.aceptado;
              }
              return true;
            }).toList();

            if (applications.isEmpty) {
              return Text(
                (request.status == ServiceStatus.inProgress || request.status == ServiceStatus.completed)
                    ? 'No hay un trabajador asignado' 
                    : 'Aún no hay postulaciones para esta solicitud',
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
              itemBuilder: (context, index) =>
                  PostulacionItem(
                    application: applications[index], 
                    request: request,
                  ),
            );
          },
        ),
      ],
    );
  }
}

/// Item individual de postulación con datos del trabajador.
class PostulacionItem extends ConsumerWidget {
  final ApplicationEntity application;
  final RequestEntity request;

  const PostulacionItem({
    super.key, 
    required this.application,
    required this.request,
  });

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
          workerId: worker.id,
          applicationId: application.id,
          request: request,
          nombreTrabajador: worker.nombreCompleto,
          especialidad: worker.sobreMi.isNotEmpty
              ? worker.sobreMi
              : 'Trabajador',
          rating: 4.9,
          trabajosRealizados: 42,
          celular: worker.celular,
          onWhatsApp: () => CommunicationService.openWhatsApp(worker.celular),
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
