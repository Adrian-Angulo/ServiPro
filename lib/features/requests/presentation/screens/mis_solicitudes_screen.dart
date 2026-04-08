import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_filter_provider.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/create_request_screen.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';
import 'package:servi_pro/features/requests/presentation/widgets/empty_requests_widget.dart';
import 'package:servi_pro/features/requests/presentation/widgets/request_card.dart';
import 'package:servi_pro/features/requests/presentation/widgets/request_filter_chip.dart';

class MisSolicitudesScreen extends ConsumerWidget {
  const MisSolicitudesScreen({super.key});

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
  String _formatTime(DateTime dateCreated) {
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

  // Filtrar solicitudes
  List<RequestEntity> _filterRequests(
    List<RequestEntity> requests,
    RequestFilterType filter,
    String userId,
  ) {
    // Filtrar por usuario
    var filtered = requests.where((r) => r.idClient == userId).toList();

    // Filtrar por estado
    if (filter != RequestFilterType.todos) {
      filtered = filtered.where((r) {
        final uiStatus = _mapStatusToUI(r.status);
        return uiStatus == filter.label;
      }).toList();
    }

    // Ordenar por fecha (más recientes primero)
    filtered.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

    return filtered;
  }

  // Contar solicitudes por estado
  Map<RequestFilterType, int> _countByStatus(
    List<RequestEntity> requests,
    String userId,
  ) {
    final userRequests = requests.where((r) => r.idClient == userId).toList();

    return {
      RequestFilterType.todos: userRequests.length,
      RequestFilterType.pendiente: userRequests
          .where((r) => _mapStatusToUI(r.status) == 'Pendiente')
          .length,
      RequestFilterType.enProgreso: userRequests
          .where((r) => _mapStatusToUI(r.status) == 'En progreso')
          .length,
      RequestFilterType.completado: userRequests
          .where((r) => _mapStatusToUI(r.status) == 'Completado')
          .length,
      RequestFilterType.cancelado: userRequests
          .where((r) => _mapStatusToUI(r.status) == 'Cancelado')
          .length,
    };
  }

  // Cancelar solicitud
  Future<void> _cancelRequest(
    BuildContext context,
    WidgetRef ref,
    String requestId,
  ) async {
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
        .deleteRequest(id: requestId);

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
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestNotifierProvider);
    final selectedFilter = ref.watch(requestFilterProvider);

    // Obtener usuario autenticado
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.when(
      data: (user) => user?.id,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mis Solicitudes', style: AppTypography.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateRequestScreen(),
                ),
              );
            },
            tooltip: 'Nueva solicitud',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filtros horizontales
            requestsAsync.when(
              data: (requests) {
                if (userId == null) return const SizedBox.shrink();

                final counts = _countByStatus(requests, userId);

                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    itemCount: RequestFilterType.values.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final filter = RequestFilterType.values[index];
                      return RequestFilterChip(
                        label: filter.label,
                        isSelected: selectedFilter == filter,
                        count: counts[filter],
                        onTap: () {
                          ref.read(requestFilterProvider.notifier).state =
                              filter;
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(height: 60),
              error: (_, __) => const SizedBox(height: 60),
            ),

            const Divider(height: 1),

            // Lista de solicitudes
            Expanded(
              child: requestsAsync.when(
                data: (requests) {
                  if (userId == null) {
                    return const Center(child: Text('Debes iniciar sesión'));
                  }

                  final filteredRequests = _filterRequests(
                    requests,
                    selectedFilter,
                    userId,
                  );

                  if (filteredRequests.isEmpty) {
                    return EmptyRequestsWidget(
                      filterType: selectedFilter.label,
                      onCreateRequest: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateRequestScreen(),
                          ),
                        );
                      },
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(requestNotifierProvider.notifier)
                          .refresh();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(
                        AppSpacing.screenHorizontal,
                      ),
                      itemCount: filteredRequests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.lg),
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        final uiStatus = _mapStatusToUI(request.status);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VerDetallesSolicitudScreen(
                                      request: request,
                                    ),
                              ),
                            );
                          },
                          child: RequestCard(
                            status: uiStatus,
                            title: request.title,
                            description: request.details,
                            time: _formatTime(request.dateCreated),
                            onCancel: uiStatus == 'Pendiente'
                                ? () =>
                                      _cancelRequest(context, ref, request.id!)
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Error al cargar solicitudes',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.grey900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          error.toString(),
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        ElevatedButton.icon(
                          onPressed: () {
                            ref
                                .read(requestNotifierProvider.notifier)
                                .refresh();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                              vertical: AppSpacing.lg,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusLg,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
