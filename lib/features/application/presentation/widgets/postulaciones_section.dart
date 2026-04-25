import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/cards/postulacion_card.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sección que muestra las postulaciones de una solicitud (vista cliente).
class PostulacionesSection extends ConsumerWidget {
  final String requestId;

  const PostulacionesSection({super.key, required this.requestId});

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
              itemBuilder: (context, index) =>
                  PostulacionItem(application: applications[index]),
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

  const PostulacionItem({super.key, required this.application});

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
