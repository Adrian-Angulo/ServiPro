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
import 'package:servi_pro/features/application/domain/entities/application_entity.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

class MisPostulacionesScreen extends ConsumerStatefulWidget {
  const MisPostulacionesScreen({super.key});

  @override
  ConsumerState<MisPostulacionesScreen> createState() =>
      _MisPostulacionesScreenState();
}

class _MisPostulacionesScreenState
    extends ConsumerState<MisPostulacionesScreen> {
  final filtros = [
    "Todos",
    "Plomería",
    "Electricidad",
    "Instalaciones",
    "Electrodomésticos",
    "Limpieza",
    "Pintura",
    "Carpintería",
    "Construcción",
    "Cerrajería",
  ];
  String seletedFilter = "Todos";

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
    final applicationsState = ref.watch(workerApplicationsProvider);
    final requestsState = ref.watch(requestNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mis Postulaciones', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: applicationsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            ErrorRetryWidget(message: e.toString(), onRetry: _reload),
        data: (applications) {
          final requests = requestsState.maybeWhen(
            data: (r) => r,
            orElse: () => <RequestEntity>[],
          );

          final filtered = seletedFilter == "Todos"
              ? applications
              : applications.where((app) {
                  final request = requests.firstWhere(
                    (r) => r.id == app.idrequest,
                    orElse: () => RequestEntity(
                      id: '',
                      idClient: '',
                      idTypeService: '',
                      details: '',
                      addres: '',
                      title: '',
                    ),
                  );
                  return request.idTypeService == seletedFilter;
                }).toList();

          if (filtered.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.work_outline,
              title: 'No tienes postulaciones aún',
              subtitle: 'Explora las solicitudes disponibles y postúlate',
            );
          }

          return _buildList(filtered, requests);
        },
      ),
    );
  }

  Widget _buildList(
    List<ApplicationEntity> applications,
    List<RequestEntity> requests,
  ) {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filtros.length,
              itemBuilder: (context, index) {
                final filtro = filtros[index];
                final isSelected = seletedFilter == filtro;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        seletedFilter = filtro;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1E3A5F)
                            : Colors.white,
                        border: Border.all(
                          width: 1,
                          color: isSelected
                              ? const Color(0xFF1E3A5F)
                              : const Color.fromRGBO(203, 213, 225, 1),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        filtro,
                        style: TextStyle(
                          color: isSelected
                              ? const Color.fromRGBO(203, 213, 225, 1)
                              : const Color(0xFF1E3A5F),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              itemCount: applications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final app = applications[index];
                final request = requests.firstWhere(
                  (r) => r.id == app.idrequest,
                  orElse: () => RequestEntity(
                    id: '',
                    idClient: '',
                    idTypeService: '',
                    details: '',
                    addres: '',
                    title: '',
                  ),
                );
                return ApplicationCard(application: app, request: request);
              },
            ),
          ),
        ],
      ),
    );
  }
}
