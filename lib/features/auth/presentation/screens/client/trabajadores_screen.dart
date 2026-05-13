import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/widgets/cards/worker_card.dart';

class TrabajadoresScreen extends ConsumerWidget {
  const TrabajadoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWorkersAsync = ref.watch(allWorkersProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Trabajadores Disponibles',
            style: AppTypography.headlineMedium,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: allWorkersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Error al cargar trabajadores',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error.toString(),
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          data: (trabajadores) {
            if (trabajadores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 64,
                      color: AppColors.grey300,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No hay trabajadores disponibles',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Intenta más tarde', style: AppTypography.bodyMedium),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contador de trabajadores
                  Text(
                    '${trabajadores.length} profesionales encontrados',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                      color: AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Lista de trabajadores
                  Expanded(
                    child: ListView.separated(
                      itemCount: trabajadores.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final trabajador = trabajadores[index];
                        return WorkerCard(
                          trabajador: trabajador,
                          onTap: () {
                            // TODO: Navegar a perfil del trabajador
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Perfil de ${trabajador.nombreCompleto}',
                                ),
                              ),
                            );
                          },
                          onMessageTap: () {
                            // TODO: Abrir chat con el trabajador
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Chat con ${trabajador.nombreCompleto}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
