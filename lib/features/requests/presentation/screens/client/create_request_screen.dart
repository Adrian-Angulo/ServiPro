import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/form/action_buttons.dart';
import 'package:servi_pro/features/requests/presentation/widgets/cards/service_category_card.dart';
import 'package:servi_pro/core/widgets/inputs/title_input_field.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  // Datos del formulario
  String? selectedCategory;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Datos de ubicación
  LatLng? selectedLocation;
  String? selectedAddress;

  // Focus nodes
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  // Estado de carga
  bool _isLoading = false;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.plumbing, 'label': 'Plomería'},
    {'icon': Icons.electric_bolt_rounded, 'label': 'Electricidad'},
    {'icon': Icons.carpenter, 'label': 'Carpintería'},
    {'icon': Icons.cleaning_services, 'label': 'Limpieza'},
    {'icon': Icons.format_paint, 'label': 'Pintura'},
    {'icon': Icons.miscellaneous_services, 'label': 'Otros'},
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
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

  Future<void> _handlePublish() async {
    if (!_isFormValid) {
      _showErrorSnackBar('Por favor completa todos los campos');
      return;
    }

    // Obtener el usuario autenticado
    final authState = ref.read(authNotifierProvider);
    final userId = authState.when(
      data: (user) => user?.id, // Usar 'id' en lugar de 'uid'
      loading: () => null,
      error: (_, __) => null,
    );

    if (userId == null) {
      _showErrorSnackBar('Debes iniciar sesión para crear una solicitud');
      return;
    }

    setState(() => _isLoading = true);

    // Crear la entidad de solicitud
    final request = RequestEntity(
      idClient: userId,
      title: titleController.text.trim(),
      idTypeService: selectedCategory!,
      details: descriptionController.text.trim(),
      addres: addressController.text.trim(),
    );

    // Debug: Imprimir datos
    debugPrint('📝 Creando solicitud:');
    debugPrint('   Usuario: $userId');
    debugPrint('   Título: ${request.title}');
    debugPrint('   Categoría: ${request.idTypeService}');
    debugPrint('   Descripción: ${request.details}');
    debugPrint('   Dirección: ${request.addres}');

    // Registrar la solicitud
    final failure = await ref
        .read(requestNotifierProvider.notifier)
        .registerRequest(request: request);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (failure != null) {
      // Mostrar error
      _showErrorSnackBar(failure.message);
    } else {
      // Éxito
      _showSuccessSnackBar('Solicitud publicada exitosamente');

      // Esperar un momento y cerrar la pantalla
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
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
          onPressed: _isLoading ? null : _handleCancel,
        ),
        title: Text('Solicitar un Oficio', style: AppTypography.titleLarge),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
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
                              onTap: _isLoading
                                  ? () {}
                                  : () {
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
                          hasFocus: false,
                          labelText: "Título de la solicitud",
                          hintText: "Ej. Reparación de Grifo",
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TitleInputField(
                          controller: descriptionController,
                          focusNode: _descriptionFocusNode,
                          hasFocus: false,
                          labelText: "Descripción breve",
                          hintText:
                              'Describe el problema o servicio que necesitas. Incluye detalles importantes como urgencia, materiales necesarios, etc.',
                          icon: Icons.description_outlined,
                          maxLines: 5,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Ubicación', style: AppTypography.titleLarge),
                        const SizedBox(height: AppSpacing.xs),
                        TitleInputField(
                          controller: addressController,
                          focusNode: FocusNode(),
                          hasFocus: false,
                          labelText: "Dirección",
                          hintText: "Ej: Cra 24 #17-21, Barrio chapal",
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: AppColors.blackOverlay25,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text('Publicando solicitud...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: _isLoading
          ? null
          : Container(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackOverlay10,
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ActionButtons(
                onCancel: _handleCancel,
                onPublish: _handlePublish,
                isEnabled: _isFormValid,
              ),
            ),
    );
  }
}
