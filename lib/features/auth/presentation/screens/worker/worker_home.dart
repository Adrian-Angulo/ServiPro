import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/auth/presentation/screens/worker/mis_postulaciones_screen.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/worker/profile_worker.dart';
import 'package:servi_pro/features/auth/presentation/screens/worker/solicitudes_worker_screen.dart';

class WorketHome extends ConsumerStatefulWidget {
  const WorketHome({super.key});

  @override
  ConsumerState<WorketHome> createState() => _WorketHomeState();
}

class _WorketHomeState extends ConsumerState<WorketHome> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        ref.read(workerApplicationsProvider.notifier).load(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Center(child: Text('Inicio')),
      const SolicitudesWorkerScreen(),
      const MisPostulacionesScreen(),
      const ProfileWorker(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        showUnselectedLabels: true,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
            activeIcon: Icon(Icons.near_me_rounded),
            label: 'Aplicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            activeIcon: Icon(Icons.notifications_active_sharp),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
