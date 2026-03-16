import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/providers/registro_trabajador_provider.dart';
import 'package:servi_pro/features/auth/widgets/register_form.dart';
import 'package:servi_pro/features/auth/widgets/auth_widgets.dart';

class RegistroTrabajadorScreen extends ConsumerStatefulWidget {
  const RegistroTrabajadorScreen({super.key});

  @override
  ConsumerState<RegistroTrabajadorScreen> createState() =>
      _RegistroTrabajadorScreenState();
}

class _RegistroTrabajadorScreenState
    extends ConsumerState<RegistroTrabajadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _form = RegistroTrabajadorForm();

  @override
  void initState() {
    super.initState();
    _form.initFromState(ref.read(registroTrabajadorProvider));
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    _form.syncProvider(ref.read(registroTrabajadorProvider.notifier));
  }

  void _crearCuenta() {
    if (_formKey.currentState!.validate()) {
      // TODO: llamar al repositorio de auth
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registroTrabajadorProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  const AuthBackButton(),
                  const SizedBox(width: AppSpacing.md),
                  Text('Registro de Trabajador', style: AppTypography.titleLarge),
                ],
              ),
            ),

            // Formulario scrollable
            Expanded(
              child: RegistroTrabajadorBody(
                formKey: _formKey,
                form: _form,
                onChanged: _onFormChanged,
              ),
            ),

            // Boton Crear mi cuenta
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.xl,
              ),
              child: AuthPrimaryButton(
                label: 'Crear mi cuenta',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: state.isValid ? _crearCuenta : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}