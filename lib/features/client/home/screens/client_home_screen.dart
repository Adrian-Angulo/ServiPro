import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/client/home/presentation/home_provider.dart';
import 'package:servi_pro/features/client/home/widgets/home_action_cards.dart';
import 'package:servi_pro/features/client/home/widgets/home_header.dart';
import 'package:servi_pro/features/client/home/widgets/recommended_workers_section.dart';
import 'package:servi_pro/features/client/my_requests/presentation/screens/my_requests_screen.dart';

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(clientNameProvider);
    final navIndex = ref.watch(bottomNavIndexProvider);

    // Lista de pantallas para cada pestaña del bottom nav
    final screens = [
      // Pestaña 0: Inicio
      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: userName),
              const SizedBox(height: AppSpacing.xl),
              Text('¡Hola, $userName! 👋', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '¿Qué servicio necesitas hoy?',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: AppSpacing.xl),
              const HomeActionCards(),
              const SizedBox(height: AppSpacing.xxl),
              const RecommendedWorkersSection(),
            ],
          ),
        ),
      ),
      // Pestaña 1: Mis Solicitudes
      const MyRequestsScreen(),
      // Pestaña 2 y 3: Próximamente
      const Center(child: Text('Trabajadores - Próximamente')),
      const Center(child: Text('Perfil - Próximamente')),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: screens[navIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        currentIndex: navIndex,
        onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Mis solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), label: 'Trabajadores'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}
