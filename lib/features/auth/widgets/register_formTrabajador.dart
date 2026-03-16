import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/providers/registro_trabajador_provider.dart';

class RegistroTrabajadorForm {
  final nombreCompleto = TextEditingController();
  final edad = TextEditingController();
  final ciudad = TextEditingController();
  final correo = TextEditingController();
  final celular = TextEditingController();
  final cedula = TextEditingController();
  final sobreMi = TextEditingController();

  void initFromState(RegistroTrabajadorState state) {
    nombreCompleto.text = state.nombreCompleto;
    edad.text = state.edad;
    ciudad.text = state.ciudad;
    correo.text = state.correo;
    celular.text = state.celular;
    cedula.text = state.cedula;
    sobreMi.text = state.sobreMi;
  }

  void syncProvider(RegistroTrabajadorNotifier notifier) {
    notifier.update(
      nombreCompleto: nombreCompleto.text,
      edad: edad.text,
      ciudad: ciudad.text,
      correo: correo.text,
      celular: celular.text,
      cedula: cedula.text,
      sobreMi: sobreMi.text,
    );
  }

  void dispose() {
    nombreCompleto.dispose();
    edad.dispose();
    ciudad.dispose();
    correo.dispose();
    celular.dispose();
    cedula.dispose();
    sobreMi.dispose();
  }
}

class RegistroTrabajadorBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final RegistroTrabajadorForm form;
  final VoidCallback onChanged;
  final bool isValid;
  final VoidCallback onCrearCuenta;
  final VoidCallback onIniciarSesion;

  const RegistroTrabajadorBody({
    super.key,
    required this.formKey,
    required this.form,
    required this.onChanged,
    required this.isValid,
    required this.onCrearCuenta,
    required this.onIniciarSesion,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(icon: Icons.person_outline_rounded, label: 'Informacion Basica'),
            const SizedBox(height: AppSpacing.md),

            _AuthField(
              label: 'Nombre Completo',
              hint: 'Ej. Juan Perez',
              controller: form.nombreCompleto,
              onChanged: onChanged,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _AuthField(
                    label: 'Edad',
                    hint: '25',
                    controller: form.edad,
                    onChanged: onChanged,
                    keyboardType: TextInputType.number,
                    customValidator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null) return 'Ingresa un numero valido';
                      if (n < 18) return 'Debes tener al menos 18 anos';
                      if (n > 99) return 'Ingresa una edad valida';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _AuthField(
                    label: 'Ciudad',
                    hint: 'Ej. Pasto',
                    controller: form.ciudad,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            _AuthField(
              label: 'Correo Electronico',
              hint: 'ejemplo@correo.com',
              controller: form.correo,
              onChanged: onChanged,
              keyboardType: TextInputType.emailAddress,
              customValidator: (v) {
                if (v == null || v.isEmpty) return 'Campo requerido';
                final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(v)) return 'Ingresa un correo valido';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _AuthField(
                    label: 'Celular',
                    hint: '300 123 4567',
                    controller: form.celular,
                    onChanged: onChanged,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    minLength: 10,
                    lengthErrorMsg: 'El celular debe tener exactamente 10 digitos',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _AuthField(
                    label: 'Cedula / ID',
                    hint: '12345678',
                    controller: form.cedula,
                    onChanged: onChanged,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    minLength: 8,
                    lengthErrorMsg: 'La cedula debe tener entre 8 y 10 digitos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SectionHeader(icon: Icons.build_outlined, label: 'Detalles Profesionales'),
            const SizedBox(height: AppSpacing.md),
            _DetallesProfesionalesCard(),
            const SizedBox(height: AppSpacing.xl),

            _SectionHeader(icon: Icons.format_list_bulleted_rounded, label: 'Sobre ti'),
            const SizedBox(height: AppSpacing.sm),
            Text('Cuentanos sobre ti',
                style: AppTypography.bodySmall.copyWith(color: AppColors.grey700)),
            const SizedBox(height: AppSpacing.sm),

            _AuthField(
              label: '',
              hint: 'Describe tus habilidades, que tipo de trabajos prefieres y cualquier detalle que ayude a los clientes a confiar en ti...',
              controller: form.sobreMi,
              onChanged: onChanged,
              maxLines: 5,
              required: false,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Botón Crear cuenta
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isValid ? onCrearCuenta : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primaryOverlay50,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  elevation: 0,
                ),
                child: Text(
                  'Crear cuenta',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.onPrimary, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Ya tienes una cuenta? ',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.grey700),
                ),
                GestureDetector(
                  onTap: onIniciarSesion,
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
        Text(label,
            style: AppTypography.titleMedium
                .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _DetallesProfesionalesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryOverlay10,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.work_outline_rounded,
                  color: AppColors.primary, size: AppSpacing.iconMd),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text('Agregar Detalle Profesional y Portafolio',
                  style: AppTypography.titleSmall, textAlign: TextAlign.center),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.grey500, size: AppSpacing.iconMd),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final bool required;
  final int? maxLength;
  final int? minLength;
  final String? lengthErrorMsg;
  final String? Function(String?)? customValidator;

  const _AuthField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.required = true,
    this.maxLength,
    this.minLength,
    this.lengthErrorMsg,
    this.customValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.grey700)),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: (_) => onChanged(),
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            filled: true,
            fillColor: AppColors.surface,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.md),
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
              if (minLength != null && maxLength != null && minLength == maxLength && v.length != minLength!) {
                return lengthErrorMsg ?? 'Debe tener exactamente $minLength digitos';
              }
              if (minLength != null && v.length < minLength!) {
                return lengthErrorMsg ?? 'Minimo $minLength digitos';
              }
              if (maxLength != null && v.length > maxLength!) {
                return lengthErrorMsg ?? 'Maximo $maxLength digitos';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}