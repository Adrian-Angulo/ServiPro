import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/cliente.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_avatar_widget.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_info_section.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_logout_button.dart';
import 'package:servi_pro/features/auth/presentation/widgets/worker_profile/worker_section_title.dart';

class PerfilCliente extends ConsumerStatefulWidget {
  const PerfilCliente({super.key});

  @override
  ConsumerState<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends ConsumerState<PerfilCliente> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).logout();
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _showEditDialog(String field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar $field - Funcionalidad próximamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCameraOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambiar foto - Funcionalidad próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null || user is! Cliente) {
          return const Center(
            child: Text('No se pudo cargar la información del perfil'),
          );
        }

        final cliente = user;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.md),

                // Avatar con iniciales
                ClientAvatarWidget(
                  nombre: cliente.nombre,
                  onCameraPressed: _showCameraOptions,
                ),

                const SizedBox(height: AppSpacing.md),

                // Nombre del cliente
                Text(
                  cliente.nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xs),

                // Email del cliente
                Text(
                  cliente.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Título de sección: Información Personal
                const Align(
                  alignment: Alignment.centerLeft,
                  child: WorkerSectionTitle(title: 'Información Personal'),
                ),

                const SizedBox(height: AppSpacing.md),

                // Campos de información
                ClientInfoSection(
                  cliente: cliente,
                  onEditName: () => _showEditDialog('nombre'),
                  onEditEmail: () => _showEditDialog('correo'),
                  onEditPhone: () => _showEditDialog('teléfono'),
                  onEditCity: () => _showEditDialog('ciudad'),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Botón de cerrar sesión
                ClientLogoutButton(
                  onPressed: _handleLogout,
                  isLoading: _isLoggingOut,
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Error al cargar el perfil',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
