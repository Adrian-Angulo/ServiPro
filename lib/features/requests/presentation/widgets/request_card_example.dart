import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/requests/presentation/widgets/request_card.dart';

/// Ejemplo de uso del RequestCard
/// Este archivo es solo para demostración y puede ser eliminado
class RequestCardExample extends StatelessWidget {
  const RequestCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplo RequestCard')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          // Ejemplo 1: Solicitud pendiente
          RequestCard(
            status: 'Pendiente',
            title: 'Mantenimiento preventivo calefón',
            description:
                'Limpieza general y revisión de válvulas para calefón a gas. Se requiere para el fin de...',
            time: 'Hace 4 horas',
            onCancel: () {
              print('Cancelar solicitud');
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Ejemplo 2: Solicitud en progreso
          RequestCard(
            status: 'En progreso',
            title: 'Reparación de grifo de cocina',
            description:
                'Tengo una fuga en el grifo de la cocina que necesita reparación inmediata. El agua gotea constantemente.',
            time: 'Hace 2 días',
            onCancel: () {
              print('Cancelar solicitud');
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Ejemplo 3: Solicitud completada (sin botón)
          const RequestCard(
            status: 'Completado',
            title: 'Instalación de lámpara',
            description:
                'Instalación de lámpara LED en el techo del comedor. Incluye cableado y soporte.',
            time: 'Hace 1 semana',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Ejemplo 4: Solicitud cancelada
          const RequestCard(
            status: 'Cancelado',
            title: 'Pintura de habitación',
            description:
                'Pintura completa de habitación principal, incluye preparación de paredes y dos manos de pintura.',
            time: 'Hace 3 días',
          ),
        ],
      ),
    );
  }
}
