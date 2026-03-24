import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/screens/register_screen.dart';
import 'package:servi_pro/features/auth/presentation/screens/registro_trabajador_screen.dart';
import 'package:servi_pro/features/auth/presentation/widgets/auth_widgets.dart';

enum Rol { cliente, trabajador }

class SeleccionRolScreen extends StatefulWidget {
  const SeleccionRolScreen({super.key});

  @override
  State<SeleccionRolScreen> createState() => _SeleccionRolScreenState();
}

class _SeleccionRolScreenState extends State<SeleccionRolScreen> {
  Rol? rolSeleccionado;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: back + stepper
              const SizedBox(height: AppSpacing.xxl),

              // Titulo
              Text('¿Cómo usarás la app?', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Selecciona tu perfil para personalizar tu experiencia en Pasto.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tarjeta Cliente
              _RolCard(
                icon: Icons.home_rounded,
                iconBgColor: AppColors.primaryOverlay10,
                iconColor: AppColors.primary,
                titulo: 'Soy Usuario',
                descripcion:
                    'Busco expertos para reparaciones o tareas en mi hogar.',
                seleccionado: rolSeleccionado == Rol.cliente,
                onTap: () {
                  setState(() {
                    rolSeleccionado = Rol.cliente;
                  });
                } /* ref.read(rolSeleccionadoProvider.notifier).state =
                    TipoRol.cliente, */,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tarjeta Trabajador
              _RolCard(
                icon: Icons.engineering_rounded,
                iconBgColor: AppColors.accentOverlay10,
                iconColor: AppColors.accent,
                titulo: 'Soy Trabajador',
                descripcion:
                    'Quiero ofrecer mis servicios y encontrar nuevos clientes.',
                seleccionado:
                    rolSeleccionado ==
                    Rol.trabajador /* rolSeleccionado == TipoRol.trabajador */,
                onTap: () {
                  setState(() {
                    rolSeleccionado = Rol.trabajador;
                  });
                } /* ref.read(rolSeleccionadoProvider.notifier).state =
                    TipoRol.trabajador, */,
              ),

              const Spacer(),

              // BotÃ³n Continuar
              AuthPrimaryButton(
                label: 'Continuar',
                onPressed: rolSeleccionado != null
                    ? () {
                        if (rolSeleccionado == Rol.trabajador) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistroTrabajadorScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        }
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Ciudad
              Center(
                child: Text(
                  'PASTO, NARIÑO',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.grey500,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _RolCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String titulo;
  final String descripcion;
  final bool seleccionado;
  final VoidCallback onTap;

  const _RolCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.titulo,
    required this.descripcion,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: seleccionado ? AppColors.primary : AppColors.grey300,
            width: seleccionado ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackOverlay10,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ãcono
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: iconColor, size: AppSpacing.iconLg),
            ),
            const SizedBox(width: AppSpacing.lg),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    descripcion,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),

            // Radio
            Radio<bool>(
              value: true,
              groupValue: seleccionado,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
