import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/worket_home.dart';
import 'package:servi_pro/features/auth/presentation/widgets/auth_widgets.dart';

class RegistroTrabajadorScreen extends ConsumerStatefulWidget {
  const RegistroTrabajadorScreen({super.key});

  @override
  ConsumerState<RegistroTrabajadorScreen> createState() =>
      _RegistroTrabajadorScreenState();
}

class _RegistroTrabajadorScreenState
    extends ConsumerState<RegistroTrabajadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _correoController = TextEditingController();
  final _celularController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _sobreMiController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCity = 'Pasto, Nariño';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _correoController.dispose();
    _celularController.dispose();
    _cedulaController.dispose();
    _sobreMiController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authNotifierProvider.notifier)
        .registerTrabajador(
          email: _correoController.text.trim(),
          password: _passwordController.text,
          nombreCompleto: _nombreController.text.trim(),
          edad: int.parse(_edadController.text),
          ciudad: _selectedCity,
          celular: _celularController.text.trim(),
          cedula: _cedulaController.text.trim(),
          sobreMi: _sobreMiController.text.trim(),
        );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WorketHome()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  const AuthBackButton(),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Registro de Trabajador',
                    style: AppTypography.titleLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.sm,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        icon: Icons.person_outline_rounded,
                        label: 'Información Básica',
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _AuthField(
                        label: 'Nombre Completo',
                        hint: 'Ej. Juan Pérez',
                        controller: _nombreController,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Row(
                        children: [
                          Expanded(
                            child: _AuthField(
                              label: 'Edad',
                              hint: '25',
                              controller: _edadController,
                              keyboardType: TextInputType.number,
                              customValidator: (v) {
                                final n = int.tryParse(v ?? '');
                                if (n == null)
                                  return 'Ingresa un número válido';
                                if (n < 18)
                                  return 'Debes tener al menos 18 años';
                                if (n > 99) return 'Ingresa una edad válida';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ciudad',
                                  style: AppTypography.labelMedium,
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedCity,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.accent,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                  items:
                                      [
                                            'Pasto, Nariño',
                                            'Bogotá',
                                            'Medellín',
                                            'Cali',
                                          ]
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(
                                                c,
                                                style: AppTypography.bodyMedium,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) =>
                                      setState(() => _selectedCity = v!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _AuthField(
                        label: 'Correo Electrónico',
                        hint: 'ejemplo@correo.com',
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        customValidator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          if (!v.contains('@'))
                            return 'Ingresa un correo válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Row(
                        children: [
                          Expanded(
                            child: _AuthField(
                              label: 'Celular',
                              hint: '3001234567',
                              controller: _celularController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              minLength: 10,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _AuthField(
                              label: 'Cédula / ID',
                              hint: '12345678',
                              controller: _cedulaController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              minLength: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      _SectionHeader(
                        icon: Icons.lock_outline_rounded,
                        label: 'Seguridad',
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _AuthField(
                        label: 'Contraseña',
                        hint: 'Mínimo 6 caracteres',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.grey500,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        customValidator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Ingresa una contraseña';
                          if (v.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _AuthField(
                        label: 'Confirmar Contraseña',
                        hint: 'Repite tu contraseña',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.grey500,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        customValidator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Confirma tu contraseña';
                          if (v != _passwordController.text)
                            return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      _SectionHeader(
                        icon: Icons.format_list_bulleted_rounded,
                        label: 'Sobre ti',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Cuéntanos sobre ti',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      _AuthField(
                        label: '',
                        hint:
                            'Describe tus habilidades, qué tipo de trabajos prefieres y cualquier detalle que ayude a los clientes a confiar en ti...',
                        controller: _sobreMiController,
                        maxLines: 5,
                        required: false,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      if (authState.hasError) ...[
                        Text(
                          authState.error.toString(),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _crearCuenta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor: AppColors.primaryOverlay50,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 0,
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Crear cuenta',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: AppColors.onPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta? ',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                ),
                            child: Text(
                              'Inicia sesión',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final bool required;
  final int? maxLength;
  final int? minLength;
  final String? Function(String?)? customValidator;
  final bool obscureText;
  final Widget? suffixIcon;

  const _AuthField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.required = true,
    this.maxLength,
    this.minLength,
    this.customValidator,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: AppColors.grey700),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: obscureText,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: AppColors.surface,
            counterText: '',
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
          validator: (v) {
            if (customValidator != null) return customValidator!(v);
            if (required && (v == null || v.isEmpty)) return 'Campo requerido';
            if (v != null && v.isNotEmpty) {
              if (minLength != null &&
                  maxLength != null &&
                  minLength == maxLength &&
                  v.length != minLength!) {
                return 'Debe tener exactamente $minLength dígitos';
              }
              if (minLength != null && v.length < minLength!) {
                return 'Mínimo $minLength dígitos';
              }
              if (maxLength != null && v.length > maxLength!) {
                return 'Máximo $maxLength dígitos';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
