import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/widgets/register_formTrabajador.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
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
  final _form = RegistroTrabajadorForm();


  void _crearCuenta() {
    if (_formKey.currentState!.validate()) {
      // TODO: llamar al repositorio de auth
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    

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

            // Formulario scrollable con botón al final
            Expanded(
              child: RegistroTrabajadorBody(
                formKey: _formKey,
                form: _form,
                onChanged: (){},
                //TODO: CAMBIAR EL isValid
                isValid: true,
                onCrearCuenta: _crearCuenta,
                onIniciarSesion: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}