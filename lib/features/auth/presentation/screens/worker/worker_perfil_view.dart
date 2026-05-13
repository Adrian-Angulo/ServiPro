import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/domain/enums/rol.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/core/utils/communication_service.dart';
import 'package:servi_pro/features/application/presentation/providers/add_application_notifier.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/core/utils/enums.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/reviews/domain/entities/review_entity.dart';
import 'package:servi_pro/features/reviews/presentation/providers/review_providers.dart';
import 'package:servi_pro/features/reviews/presentation/widgets/add_review_dialog.dart';

class WorkerPerfilView extends ConsumerStatefulWidget {
  final String workerId;
  final String applicationId;
  final RequestEntity request;

  const WorkerPerfilView({
    super.key,
    required this.workerId,
    required this.applicationId,
    required this.request,
  });

  @override
  ConsumerState<WorkerPerfilView> createState() => _WorkerPerfilViewState();
}

class _WorkerPerfilViewState extends ConsumerState<WorkerPerfilView> {
  bool isLoading = false;

  Future<void> _acceptWorker() async {
    setState(() => isLoading = true);

    await ref
        .read(addAppliNotifier.notifier)
        .acceptApplication(
          applicationId: widget.applicationId,
          requestId: widget.request.id!,
        );

    if (!mounted) return;

    final result = ref.read(addAppliNotifier);

    if (result is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Error al aceptar la postulación. Intenta de nuevo.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => isLoading = false);
    } else {
      // Actualización instantánea en la UI
      widget.request.status = ServiceStatus.inProgress;

      final currentRequests = ref.read(requestNotifierProvider).valueOrNull;
      if (currentRequests != null) {
        ref.read(requestNotifierProvider.notifier).state = AsyncData([
          ...currentRequests,
        ]);
      }

      ref.invalidate(applicationsByRequestProvider(widget.request.id!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Trabajador aceptado exitosamente.'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() => isLoading = false);
      Navigator.pop(context); // Volver a la pantalla de la solicitud
    }
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(workerId: widget.workerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerAsync = ref.watch(workerByIdProvider(widget.workerId));
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSoft,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey900,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil Profesional',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: workerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar el perfil',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
        data: (worker) {
          if (worker == null) {
            return Center(
              child: Text(
                'Trabajador no encontrado',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar & Badge
                _buildAvatar(),
                const SizedBox(height: AppSpacing.md),

                // Nombre
                Text(
                  worker.nombreCompleto,
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  worker.email.isNotEmpty
                      ? worker
                            .email // Se deja "Barrio..." por ahora como mockup si se quiere
                      : '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const SizedBox(height: AppSpacing.xs),

                // Ubicación
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      worker.ciudad.isNotEmpty
                          ? worker
                                .ciudad // Se deja "Barrio..." por ahora como mockup si se quiere
                          : '',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Fila de Estadísticas (Conectada a reseñas)
                Consumer(
                  builder: (context, ref, child) {
                    final reviewsAsync = ref.watch(
                      reviewsByWorkerProvider(worker.id),
                    );
                    final double rating =
                        reviewsAsync.valueOrNull?.isNotEmpty == true
                        ? reviewsAsync.valueOrNull!
                                  .map((r) => r.rating)
                                  .reduce((a, b) => a + b) /
                              reviewsAsync.valueOrNull!.length
                        : 5.0;
                    final int reviewsCount =
                        reviewsAsync.valueOrNull?.length ?? 0;
                    return _buildStatsRow(
                      rating: rating,
                      reviewsCount: reviewsCount,
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Sobre mi
                _buildSectionTitle('Sobre mi'),
                const SizedBox(height: AppSpacing.md),
                Text(
                  worker.sobreMi.isNotEmpty
                      ? worker.sobreMi
                      : 'El trabajador no ha agregado información adicional.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),

                /*   // Especialidades
                _buildSectionTitle('Especialidades'),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: [
                      _buildSpecialtyChip('Plomería Integral'),
                      _buildSpecialtyChip('Redes Eléctricas'),
                      _buildSpecialtyChip('Instalación Sanitarios'),
                      _buildSpecialtyChip('Mantenimiento de Calentadores'),
                      _buildSpecialtyChip('Filtraciones'),
                    ],
                  ),
                ),
                const SizedBox(height: 32), */

                // Opiniones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle('Opiniones', showRightSpace: false),
                    Consumer(
                      builder: (context, ref, child) {
                        final user = ref.watch(authNotifierProvider).value;
                        final isClient = user?.rol == Rol.cliente;
                        final isCompleted =
                            widget.request.status == ServiceStatus.completed;

                        if (isClient && isCompleted) {
                          return GestureDetector(
                            onTap: _showAddReviewDialog,
                            child: Text(
                              'Añadir reseña',
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Lista de Reseñas Reales
                Consumer(
                  builder: (context, ref, child) {
                    final reviewsAsync = ref.watch(
                      reviewsByWorkerProvider(worker.id),
                    );
                    return reviewsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Text(
                        'Error al cargar reseñas',
                        style: TextStyle(color: AppColors.error),
                      ),
                      data: (reviews) {
                        if (reviews.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              'Aún no hay opiniones para este trabajador.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.grey500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return Column(
                          children: reviews.map((review) {
                            // Simple helper para calcular "hace X tiempo" (idealmente usar timeago package real)
                            final diff = DateTime.now().difference(
                              review.createdAt,
                            );
                            String timeAgo = '';
                            if (diff.inDays > 0)
                              timeAgo = 'Hace ${diff.inDays} días';
                            else if (diff.inHours > 0)
                              timeAgo = 'Hace ${diff.inHours} horas';
                            else
                              timeAgo = 'Hace unos instantes';

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _buildReviewCard(
                                name: review.clientName,
                                timeAgo: timeAgo,
                                review: '"${review.comment}"',
                                rating: review.rating,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: workerAsync.whenOrNull(
        data: (worker) {
          if (worker == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackOverlay10.withOpacity(0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showContactOptions(context, worker.celular),
                      icon: const Icon(Icons.contact_phone_rounded, size: 20),
                      label: Text(
                        'Contactar',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(
                          color: AppColors.accent,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          widget.request.status != ServiceStatus.pending ||
                              isLoading
                          ? null
                          : _acceptWorker,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                      label: Text(
                        widget.request.status == ServiceStatus.inProgress
                            ? 'Asignado'
                            : widget.request.status == ServiceStatus.completed
                            ? 'Finalizado'
                            : 'Aceptar',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary, width: 3.5),
            /* image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&h=300&fit=crop',
              ),
              fit: BoxFit.cover,
            ), */
          ),
          child: Icon(Icons.person, size: 70, color: AppColors.primary),
        ),
        /* Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.backgroundSoft,
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ), */
      ],
    );
  }

  Widget _buildStatsRow({required double rating, required int reviewsCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rating
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF4FAF9),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                rating.toStringAsFixed(1),
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviewsCount)',
                style: AppTypography.labelSmall.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Trabajos
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF4FAF9),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.handyman_rounded,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '342',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Trabajos realizados',
                style: AppTypography.labelSmall.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool showRightSpace = true}) {
    return Row(
      mainAxisSize: showRightSpace ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtyChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF233246),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String timeAgo,
    required String review,
    required double rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF64748B),
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: index < rating
                        ? AppColors.accent
                        : const Color(0xFFE2E8F0),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            review,
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context, String celular) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Agarradera (Drag handle)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Elige un método de contacto',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOverlay10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    'Llamar por teléfono',
                    style: AppTypography.titleSmall,
                  ),
                  subtitle: Text(celular, style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.pop(context);
                    CommunicationService.callPhone(celular);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentOverlay10,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  title: Text(
                    'Enviar mensaje de WhatsApp',
                    style: AppTypography.titleSmall,
                  ),
                  subtitle: Text(celular, style: AppTypography.bodySmall),
                  onTap: () {
                    Navigator.pop(context);
                    CommunicationService.openWhatsApp(celular);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}
