import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/request/presentation/request_provider.dart';
import 'package:servi_pro/features/client/request/widgets/service_category_grid.dart';
import 'package:servi_pro/features/client/request/widgets/job_description_field.dart';
import 'package:servi_pro/features/client/request/widgets/location_section.dart';
import 'package:servi_pro/core/widgets/success_dialog.dart';

class RequestServiceScreen extends ConsumerStatefulWidget {
  const RequestServiceScreen({super.key});

  @override
  ConsumerState<RequestServiceScreen> createState() =>
      _RequestServiceScreenState();
}

class _RequestServiceScreenState extends ConsumerState<RequestServiceScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(requestFormProvider);
    final notifier = ref.read(requestFormProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.backgroundSoft,
            elevation: 0,
            floating: true,
            snap: true,
            leading: const BackButton(color: AppColors.grey900),
            centerTitle: true,
            title: Text('Solicitar un Oficio', style: AppTypography.titleLarge),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('¿Qué necesitas?', style: AppTypography.titleMedium),
                    Text(
                      'PASO 1 DE 3',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ServiceCategoryGrid(
                  selected: formState.category,
                  onSelected: notifier.selectCategory,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Detalles del trabajo', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.md),
                JobDescriptionField(
                  controller: _descriptionController,
                  onChanged: notifier.setDescription,
                ),
                const SizedBox(height: AppSpacing.xl),
                LocationSection(
                  selectedZone: formState.zone,
                  onZoneChanged: notifier.selectZone,
                ),
                const SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.md,
          AppSpacing.screenHorizontal,
          AppSpacing.xl,
        ),
        child: ElevatedButton.icon(
          onPressed: formState.isValid
              ? () {
                  // TODO: llamada a Firebase — si falla muestra error, si ok muestra éxito
                  showSuccessDialog(context);
                }
              : () {
                  String mensaje = '';
                  if (formState.category == null) {
                    mensaje = 'Selecciona una categoría';
                  } else if (formState.description.trim().length < 10) {
                    mensaje = 'Escribe una descripción de al menos 10 caracteres';
                  } else if (formState.zone == null) {
                    mensaje = 'Selecciona tu zona';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(mensaje),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
          icon: const Icon(Icons.arrow_forward_rounded),
          iconAlignment: IconAlignment.end,
          label: Text(
            'Publicar solicitud',
            style: AppTypography.labelLarge.copyWith(color: AppColors.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
        ),
      ),
    );
  }
}
