import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/requests/presentation/widgets/action_buttons.dart';
import 'package:servi_pro/features/requests/presentation/widgets/location_section.dart';
import 'package:servi_pro/features/requests/presentation/widgets/request_details_section.dart';
import 'package:servi_pro/features/requests/presentation/widgets/service_category_card.dart';
import 'package:servi_pro/features/requests/presentation/widgets/title_input_field.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  String? selectedCategory;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final bool _titleHasFocus = false;
  final bool _descriptionHasFocus = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.plumbing, 'label': 'Plomería'},
    {'icon': Icons.electrical_services, 'label': 'Electricidad'},
    {'icon': Icons.carpenter, 'label': 'Carpintería'},
    {'icon': Icons.cleaning_services, 'label': 'Limpieza'},
    {'icon': Icons.format_paint, 'label': 'Pintura'},
    {'icon': Icons.more_horiz, 'label': 'Otros'},
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return selectedCategory != null &&
        titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty;
  }

  void _handleCancel() {
    if (selectedCategory != null ||
        titleController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        addressController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          title: Text(
            '¿Descartar solicitud?',
            style: AppTypography.titleMedium,
          ),
          content: Text(
            'Se perderán todos los datos ingresados',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Continuar editando',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.grey700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Descartar',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _handlePublish() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Por favor completa todos los campos',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Solicitud publicada exitosamente',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: _handleCancel,
        ),
        title: Text('Solicitar un Oficio', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¿Qué necesitas?',
                          style: AppTypography.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ServiceCategoryCard(
                          icon: category['icon'],
                          label: category['label'],
                          isSelected: selectedCategory == category['label'],
                          onTap: () {
                            setState(() {
                              selectedCategory = category['label'];
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Detalles del trabajo',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TitleInputField(
                      controller: titleController,
                      focusNode: _titleFocusNode,
                      hasFocus: _titleHasFocus,
                      labelText: "Titulo de la solicitud",
                      hintText: "Ej. Reparación de Grifo",
                    ),

                    TitleInputField(
                      controller: descriptionController,
                      focusNode: _descriptionFocusNode,
                      hasFocus: _descriptionHasFocus,
                      labelText: "Descripción breve",
                      hintText:
                          'Describe el problema o servicio que necesitas. Incluye detalles importantes como urgencia, materiales necesarios, etc.',
                      icon: Icons.description_outlined,
                      maxLines: 5,
                    ),

                    LocationSection(addressController: addressController),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        decoration: BoxDecoration(color: AppColors.surface),
        child: ActionButtons(
          onCancel: _handleCancel,
          onPublish: _handlePublish,
          isEnabled: _isFormValid,
        ),
      ),
    );
  }
}
