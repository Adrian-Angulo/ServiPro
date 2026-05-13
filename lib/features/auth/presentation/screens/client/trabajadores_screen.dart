import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/core/utils/service_category_catalog.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/client/worker_perfil_simple_view.dart';
import 'package:servi_pro/features/auth/presentation/widgets/cards/worker_card.dart';

class TrabajadoresScreen extends ConsumerStatefulWidget {
  const TrabajadoresScreen({super.key});

  @override
  ConsumerState<TrabajadoresScreen> createState() => _TrabajadoresScreenState();
}

class _TrabajadoresScreenState extends ConsumerState<TrabajadoresScreen> {
  /// Coincide con etiquetas de [kRequestServiceCategoriesOrdered] o `Todas`.
  String _selectedService = 'Todas';

  @override
  Widget build(BuildContext context) {
    final allWorkersAsync = ref.watch(allWorkersProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Trabajadores Disponibles',
            style: AppTypography.headlineMedium,
          ),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ServiceFilterPanel(
              selected: _selectedService,
              onSelect: (value) => setState(() => _selectedService = value),
            ),
            Expanded(
              child: allWorkersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Error al cargar trabajadores',
                          style: AppTypography.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          error.toString(),
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                data: (trabajadores) {
                  if (trabajadores.isEmpty) {
                    return const Center(
                      child: Text('No hay trabajadores registrados'),
                    );
                  }

                  final filtered = trabajadores.where((t) {
                    final serviceLabel = resolveWorkerProfessionToServiceLabel(
                      t.profesion,
                    );
                    final matchesService =
                        _selectedService == 'Todas' ||
                        serviceLabel == _selectedService;
                    return matchesService;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
                        child: Text(
                          'Ningún trabajador coincide con el servicio seleccionado',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${filtered.length} profesionales encontrados',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                            color: AppColors.grey700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final trabajador = filtered[index];
                              return WorkerCard(
                                trabajador: trabajador,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WorkerPerfilSimpleView(
                                            workerId: trabajador.id,
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceFilterPanel extends StatelessWidget {
  const _ServiceFilterPanel({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.grey300.withValues(alpha: 0.6)),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackOverlay10,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.handyman_outlined,
                    size: 22,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Servicio',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Elige el tipo de trabajo que buscas',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _ServiceChip(
                      label: 'Todas',
                      icon: Icons.grid_view_rounded,
                      selected: selected == 'Todas',
                      onSelected: (_) => onSelect('Todas'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    for (final def in kRequestServiceCategoriesOrdered) ...[
                      _ServiceChip(
                        label: def.label,
                        icon: def.icon,
                        selected: selected == def.label,
                        onSelected: (_) => onSelect(def.label),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? AppColors.primary : AppColors.grey700,
      ),
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      visualDensity: VisualDensity.compact,
      selectedColor: AppColors.primaryOverlay10,
      backgroundColor: AppColors.grey100,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.grey300,
        width: selected ? 1.5 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      labelStyle: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        letterSpacing: 0.1,
        color: selected ? AppColors.primary : AppColors.grey900,
      ),
    );
  }
}
