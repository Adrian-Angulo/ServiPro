import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';

class RegisterForm extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*     final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
 */
    const cities = ['Pasto, Nariño', 'Bogotá', 'Medellín', 'Cali'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre
        const _FieldLabel('Nombre completo'),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Ej. Juan Pérez',
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.grey500,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Edad + Ciudad
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Edad'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '18+'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Ciudad'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    /*  value: state.selectedCity, */
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
                    items: cities
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: AppTypography.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => {} /* notifier.setCity(v!), */,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Correo
        const _FieldLabel('Correo electrónico'),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'ServiPro@ejemplo.com',
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: AppColors.grey500,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Contraseña
        const _FieldLabel('Contraseña'),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: true/* state.obscurePassword */,
          decoration: InputDecoration(
            hintText: 'Mínimo 8 caracteres',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.grey500,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                /* state.obscurePassword
                    ? Icons.visibility_off_outlined
                    :  */Icons.visibility_outlined,
                color: AppColors.grey500,
              ),
              onPressed: (){} /* notifier.togglePassword */,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Confirmar contraseña
        const _FieldLabel('Confirmar contraseña'),
        const SizedBox(height: 8),
        TextField(
          controller: confirmController,
          obscureText: true /* state.obscureConfirm */,
          decoration: InputDecoration(
            hintText: 'Repite tu contraseña',
            prefixIcon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.grey500,
            ),
            suffixIcon: IconButton(
              icon: Icon(
               /*  state.obscureConfirm
                    ? Icons.visibility_off_outlined
                    :  */Icons.visibility_outlined,
                color: AppColors.grey500,
              ),
              onPressed: (){} /*  notifier.toggleConfirm */,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Términos — lee acceptedTerms del provider
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: true /* state.acceptedTerms */,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (v) => {} /* (v) => notifier.setTerms(v ?? false) */,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey700,
                  ),
                  children: const [
                    TextSpan(text: 'Acepto los '),
                    TextSpan(
                      text: 'términos',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: ' y '),
                    TextSpan(
                      text: 'políticas de privacidad',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Error
        /* if (state.error != null) ...[
          const SizedBox(height: 12),
          Text(
            state.error!,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ], */
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.labelMedium);
}
