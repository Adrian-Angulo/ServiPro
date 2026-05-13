import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/request_card.dart';

class InicioWorker extends ConsumerStatefulWidget {
  const InicioWorker({super.key});

  @override
  ConsumerState<InicioWorker> createState() => _InicioWorkerState();
}

class _InicioWorkerState extends ConsumerState<InicioWorker> {
  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestNotifierProvider);
    final appliWorker = ref.watch(workerApplicationsProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.screenVertical,
        ),
        child: Column(
          children: [
            requestState.when(
              data: (allData) {
                final data = allData.where((request) {
                  // Mostrar solo las solicitudes en estado pending
                  if (request.status != ServiceStatus.pending) return false;
                  // Ocultar si el trabajador ya se ha postulado
                  final hasApplied = appliWorker.any((app) => app.idrequest == request.id);
                  return !hasApplied;
                }).toList();

                if (data.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            textAlign: TextAlign.center,
                            'No hay solicitudes disponibles',
                            style: AppTypography.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Cuando lleguen nuevas solicitudes aparecerán aquí',
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final request = data[index];
                    return RequestCard(requestEntity: request);
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
