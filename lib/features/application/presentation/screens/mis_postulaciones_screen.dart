import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/widgets/empty/empty_state_widget.dart';
import 'package:servi_pro/core/widgets/feedback/error_retry_widget.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/cards/application_card.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
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

  void _reload() {
    final user = ref.read(authNotifierProvider).value;
    if (user != null) {
      ref.read(workerApplicationsProvider.notifier).load(user.id);
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: applicationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
        error: (_, __) => ErrorRetryWidget(
          message: 'Error al cargar postulaciones',
          onRetry: _reload,
        ),
        data: (applications) {
          if (applications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.work_outline,
              title: 'No tienes postulaciones aún',
              subtitle: 'Explora las solicitudes disponibles y postúlate',
            );
          }

          return requestsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildList(applications, {}),
            data: (requests) {
              final requestsMap = {for (final r in requests) r.id!: r};
              return _buildList(applications, requestsMap);
            },
          );
        },
      ),
    );
  }

  Widget _buildList(applications, requestsMap) {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: applications.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (context, index) {
          final app = applications[index];
          final request = requestsMap[app.idrequest];
          return ApplicationCard(
            application: app,
            request: request,
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
          );
        },
      ),
    );
  }
}
