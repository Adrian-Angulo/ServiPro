import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/my_requests/data/models/solicitud.dart';
import 'package:servi_pro/features/client/my_requests/presentation/my_requests_provider.dart';
import 'package:servi_pro/features/client/my_requests/widgets/filter_tabs.dart';
import 'package:servi_pro/features/client/my_requests/widgets/solicitud_card.dart';

// Pantalla principal de "Mis Solicitudes"
// ConsumerWidget nos permite leer los providers de Riverpod
class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leemos el filtro activo y la lista filtrada desde los providers
    final filtroActivo = ref.watch(filtroSolicitudProvider);
    final solicitudes = ref.watch(solicitudesFiltradas);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        leading: const BackButton(color: AppColors.grey900),
        title: Text('Mis Solicitudes', style: AppTypography.titleLarge),
      ),
      body: Column(
        children: [
          // ── Filtros ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            child: FilterTabs(
              selected: filtroActivo,
              onSelected: (nuevoFiltro) {
                // Actualizamos el filtro en el provider
                ref.read(filtroSolicitudProvider.notifier).state = nuevoFiltro;
              },
            ),
          ),

          // ── Lista de solicitudes ─────────────────────────────────────────
          Expanded(
            child: solicitudes.isEmpty
                ? _EmptyState() // Si no hay resultados, mostramos un mensaje
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: solicitudes.length,
                    itemBuilder: (context, index) {
                      final solicitud = solicitudes[index];
                      return SolicitudCard(
                        solicitud: solicitud,
                        // Solo las solicitudes pendientes tienen botón de cancelar
                        onCancelar: solicitud.estado == EstadoSolicitud.pendiente
                            ? () => _confirmarCancelacion(context, ref, solicitud)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Muestra un diálogo de confirmación antes de cancelar
  void _confirmarCancelacion(
    BuildContext context,
    WidgetRef ref,
    Solicitud solicitud,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancelar solicitud', style: AppTypography.titleMedium),
        content: Text(
          '¿Estás seguro de que quieres cancelar "${solicitud.titulo}"?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'No, volver',
              style: AppTypography.labelLarge.copyWith(color: AppColors.grey700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: llamar a Firebase para cancelar la solicitud
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Solicitud cancelada'),
                  backgroundColor: AppColors.grey900,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Sí, cancelar',
              style: AppTypography.labelLarge.copyWith(color: AppColors.onError),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget que se muestra cuando no hay solicitudes con el filtro activo
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: AppColors.grey300,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No hay solicitudes aquí',
            style: AppTypography.titleSmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Prueba con otro filtro',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}
