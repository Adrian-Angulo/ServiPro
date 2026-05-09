import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/widgets/empty/empty_state_widget.dart';
import 'package:servi_pro/core/widgets/feedback/error_retry_widget.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/screens/ver_detalles_solicitud_screen.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/request_card.dart';

class SolicitudesWorkerScreen extends ConsumerStatefulWidget {
  const SolicitudesWorkerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SolicitudesWorkerScreenState();
}

class _SolicitudesWorkerScreenState
    extends ConsumerState<SolicitudesWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    final filtros = [
      "Todos",
      "Electricidad",
      "Plomeria",
      "Instalacion",
      "Carpinteria",
      "Limpieza",
      "Otro",
    ];

    final requestsAsync = ref.watch(requestNotifierProvider);
    final applicationsAsync = ref.watch(workerApplicationsProvider);
    final user = ref.watch(authNotifierProvider).value;
    final postulationState = ref.watch(addAppliNotifier);

    final appliedRequestIds =
        applicationsAsync.valueOrNull?.map((a) => a.idrequest).toSet() ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola Carlos!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),

                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pasto, Nariño',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              //filtro horizaontal
              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                itemBuilder: (context, index) {
                  final filtro = filtros[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      child: AnimatedContainer(
                        duration: Duration(microseconds: 3000),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(203, 213, 225, 1),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(filtro),
                      ),
                    ),
                  );
                },

                itemCount: filtros.length,
              ),
            ),
            listCard(
              requestsAsync: requestsAsync,
              appliedRequestIds: appliedRequestIds,
              user: user,
              postulationState: postulationState,
            ),
          ],
        ),
      ),
    );
  }
}

class listCard extends ConsumerWidget {
  const listCard({
    super.key,
    required this.requestsAsync,
    required this.appliedRequestIds,
    required this.user,
    required this.postulationState,
  });

  final AsyncValue<List<RequestEntity>> requestsAsync;
  final Set<String> appliedRequestIds;
  final Usuario? user;
  final AsyncValue<void> postulationState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: requestsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        error: (_, __) => ErrorRetryWidget(
          message: 'Error al cargar solicitudes',
          onRetry: () => ref.invalidate(requestNotifierProvider),
        ),
        data: (requests) {
          final available = requests
              .where((r) => !appliedRequestIds.contains(r.id))
              .toList();

          if (available.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'No hay solicitudes disponibles',
              subtitle: 'Ya te postulaste a todas las solicitudes activas',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(requestNotifierProvider);
              if (user != null) {
                await ref
                    .read(workerApplicationsProvider.notifier)
                    .load(user!.id);
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              itemCount: available.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
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
                    requestEntity: request,
                    onPress: isLoading
                        ? null
                        : () async {
                            if (user == null) return;
                            await ref
                                .read(addAppliNotifier.notifier)
                                .addApplication(
                                  idWorker: user!.id,
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
                                ),
                              );
                            } else {
                              await ref
                                  .read(workerApplicationsProvider.notifier)
                                  .load(user!.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
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
