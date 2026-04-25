import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';

class MisPostulacionesScreen extends ConsumerStatefulWidget {
  const MisPostulacionesScreen({super.key});

  @override
  ConsumerState<MisPostulacionesScreen> createState() =>
      _MisPostulacionesScreenState();
}

class _MisPostulacionesScreenState
    extends ConsumerState<MisPostulacionesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        ref.read(workerApplicationsProvider.notifier).load(user.id);
      }
    });
  }

  String _mapState(String state) {
    switch (state.toLowerCase()) {
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

  Color _stateColor(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return const Color(0xFF1E3A5F);
      case 'in_progress':
        return AppColors.accent;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.grey500;
      default:
        return const Color(0xFF1E3A5F);
    }
  }

  IconData _stateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'in_progress':
        return Icons.build;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(workerApplicationsProvider);
    final requestsAsync = ref.watch(requestNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mis Postulaciones', style: AppTypography.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final user = ref.read(authNotifierProvider).value;
              if (user != null) {
                ref.read(workerApplicationsProvider.notifier).load(user.id);
              }
            },
          ),
        ],
      ),
      body: applicationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Error al cargar postulaciones',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () {
                  final user = ref.read(authNotifierProvider).value;
                  if (user != null) {
                    ref.read(workerApplicationsProvider.notifier).load(user.id);
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
        data: (applications) {
          if (applications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOverlay10,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.work_outline,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'No tienes postulaciones aún',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Explora las solicitudes disponibles y postúlate',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return requestsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildApplicationsList(applications, {}),
            data: (requests) {
              final requestsMap = {for (final r in requests) r.id!: r};
              return _buildApplicationsList(applications, requestsMap);
            },
          );
        },
      ),
    );
  }

  Widget _buildApplicationsList(
    List<ApplicationEntity> applications,
    Map<String, RequestEntity> requestsMap,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        final user = ref.read(authNotifierProvider).value;
        if (user != null) {
          await ref.read(workerApplicationsProvider.notifier).load(user.id);
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: applications.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (context, index) {
          final app = applications[index];
          final request = requestsMap[app.idrequest];
          final stateLabel = _mapState(app.state);
          final color = _stateColor(app.state);
          final icon = _stateIcon(app.state);

          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              onTap: request != null
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerDetallesSolicitudScreen(
                          request: request,
                          isWorkerView: true,
                          alreadyApplied: true,
                        ),
                      ),
                    )
                  : null,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Barra de estado
                    Container(width: 6, color: color),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(icon, size: 18, color: color),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      stateLabel.toUpperCase(),
                                      style: AppTypography.labelMedium.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOverlay10,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusFull,
                                    ),
                                  ),
                                  child: Text(
                                    'Postulación',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              request?.title ??
                                  'Solicitud #${app.idrequest.substring(0, 6)}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey900,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (request != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                request.details,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.grey700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.grey500,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      request.addres,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.grey500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
