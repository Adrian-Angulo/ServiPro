import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/screens/mis_postulaciones_screen.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/request_card.dart';

class WorketHome extends ConsumerStatefulWidget {
  const WorketHome({super.key});

  @override
  ConsumerState<WorketHome> createState() => _WorketHomeState();
}

class _WorketHomeState extends ConsumerState<WorketHome> {
  int _currentIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Center(child: Text('Inicio')),
      const SolicitudesWorkScreen(),
      const MisPostulacionesScreen(),
      const _Perfil(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Postulaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _Perfil extends ConsumerWidget {
  const _Perfil();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(authNotifierProvider.notifier).logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        child: const Text('Cerrar sesión'),
      ),
    );
  }
}

class SolicitudesWorkScreen extends ConsumerWidget {
  const SolicitudesWorkScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestNotifierProvider);
    final applicationsAsync = ref.watch(workerApplicationsProvider);
    final user = ref.watch(authNotifierProvider).value;
    final postulationState = ref.watch(addAppliNotifier);

    // IDs de solicitudes donde el trabajador ya se postuló
    final appliedRequestIds =
        applicationsAsync.valueOrNull?.map((a) => a.idrequest).toSet() ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Solicitudes disponibles', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: requestsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Error al cargar solicitudes',
                style: AppTypography.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(requestNotifierProvider),
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
        data: (requests) {
          // Filtrar solicitudes donde el trabajador ya se postuló
          final available = requests
              .where((r) => !appliedRequestIds.contains(r.id))
              .toList();

          if (available.isEmpty) {
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
                      Icons.inbox_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'No hay solicitudes disponibles',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Ya te postulaste a todas las solicitudes activas',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(requestNotifierProvider);
              if (user != null) {
                await ref
                    .read(workerApplicationsProvider.notifier)
                    .load(user.id);
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              itemCount: available.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final request = available[index];
                final isLoading = postulationState is AsyncLoading;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerDetallesSolicitudScreen(
                        request: request,
                        isWorkerView: true,
                        alreadyApplied: false,
                      ),
                    ),
                  ),
                  child: RequestCard(
                    status: request.status,
                    title: request.title,
                    description: request.details,
                    time: _formatTime(request.dateCreated),
                    onPress: isLoading
                        ? null
                        : () async {
                            if (user == null) return;

                            await ref
                                .read(addAppliNotifier.notifier)
                                .addApplication(
                                  idWorker: user.id,
                                  idRequest: request.id!,
                                );

                            final result = ref.read(addAppliNotifier);
                            if (!context.mounted) return;

                            if (result is AsyncError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Error al postularse. Intenta de nuevo.',
                                  ),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              await ref
                                  .read(workerApplicationsProvider.notifier)
                                  .load(user.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text('¡Postulación enviada!'),
                                      ],
                                    ),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusMd,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
