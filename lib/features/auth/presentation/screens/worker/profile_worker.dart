import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/trabajador.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_avatar_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_info_field.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_logout_button.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_section_title.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile_own/worker_stats_summary_widget.dart';
import 'package:servi_pro/features/reviews/domain/value_objects/worker_rating_stats.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';

class ProfileWorker extends ConsumerStatefulWidget {
  const ProfileWorker({super.key});

  @override
  ConsumerState<ProfileWorker> createState() => _ProfileWorkerState();
}

class _ProfileWorkerState extends ConsumerState<ProfileWorker> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).logout();
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _showEditDialog(String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar $field - Funcionalidad próximamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCameraOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambiar foto - Funcionalidad próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null || user is! Trabajador) {
          return const Center(
            child: Text('No se pudo cargar la información del perfil'),
          );
        }

        final trabajador = user;
        final reviewsAsync = ref.watch(reviewsByWorkerProvider(trabajador.id));

        return Scaffold(
          backgroundColor: AppColors.backgroundSoft,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundSoft,
            elevation: 0,
            title: const Text('Mi Perfil'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // Avatar con iniciales
                  ClientAvatarWidget(
                    nombre: trabajador.nombreCompleto,
                    onCameraPressed: _showCameraOptions,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Nombre del trabajador
                  Text(
                    trabajador.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Email del trabajador
                  Text(
                    trabajador.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Estadísticas
                  reviewsAsync.when(
                    data: (reviews) {
                      final stats = WorkerRatingStats.fromReviews(reviews);
                      return WorkerStatsSummaryWidget(
                        completedJobs: 0,
                        rating: stats.averageRating,
                        totalReviews: stats.reviewsCount,
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const WorkerStatsSummaryWidget(
                      completedJobs: 0,
                      rating: 0.0,
                      totalReviews: 0,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Título de sección: Información Personal
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WorkerSectionTitle(title: 'Información Personal'),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Campos de información
                  ClientInfoField(
                    icon: Icons.person_outline,
                    label: 'Nombre completo',
                    value: trabajador.nombreCompleto,
                    onEditPressed: () => _showEditDialog('nombre'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.email_outlined,
                    label: 'Correo electrónico',
                    value: trabajador.email,
                    onEditPressed: () => _showEditDialog('correo'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.phone_outlined,
                    label: 'Teléfono',
                    value: trabajador.celular,
                    onEditPressed: () => _showEditDialog('teléfono'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  ClientInfoField(
                    icon: Icons.location_on_outlined,
                    label: 'Ciudad',
                    value: trabajador.ciudad,
                    onEditPressed: () => _showEditDialog('ciudad'),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Título de sección: Sobre mí
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: WorkerSectionTitle(title: 'Sobre mí'),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Container con "Sobre mí"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Text(
                      trabajador.sobreMi,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Botón de cerrar sesión
                  ClientLogoutButton(
                    onPressed: _handleLogout,
                    isLoading: _isLoggingOut,
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Error al cargar el perfil',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
