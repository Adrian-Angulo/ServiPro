import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/screens/mis_postulaciones_screen.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/requests/presentation/screens/solicitudes_worker_screen.dart';

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
      const _Perfil(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Postulaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _Perfil extends ConsumerWidget {
  const _Perfil();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(authNotifierProvider.notifier).logout();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        child: const Text('Cerrar sesión'),
      ),
    );
  }
}
