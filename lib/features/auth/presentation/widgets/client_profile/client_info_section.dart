import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/auth/data/models/cliente.dart';
import 'package:servi_pro/features/auth/presentation/widgets/client_profile/client_info_field.dart';

/// Widget que agrupa múltiples campos de información del cliente
class ClientInfoSection extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback? onEditName;
  final VoidCallback? onEditEmail;
  final VoidCallback? onEditPhone;
  final VoidCallback? onEditCity;

  const ClientInfoSection({
    super.key,
    required this.cliente,
    this.onEditName,
    this.onEditEmail,
    this.onEditPhone,
    this.onEditCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClientInfoField(
          icon: Icons.person_outline,
          label: 'Nombre completo',
          value: cliente.nombre,
          onEditPressed: onEditName,
        ),
        const SizedBox(height: AppSpacing.sm),
        ClientInfoField(
          icon: Icons.email_outlined,
          label: 'Correo electrónico',
          value: cliente.email,
          onEditPressed: onEditEmail,
        ),
        const SizedBox(height: AppSpacing.sm),
        ClientInfoField(
          icon: Icons.phone_outlined,
          label: 'Teléfono',
          value: cliente.telefono,
          onEditPressed: onEditPhone,
        ),
        const SizedBox(height: AppSpacing.sm),
        ClientInfoField(
          icon: Icons.location_on_outlined,
          label: 'Ciudad',
          value: cliente.ciudad,
          onEditPressed: onEditCity,
        ),
      ],
    );
  }
}
