import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';
import 'package:servi_pro/features/requests/presentation/widgets/request_card.dart';

class WorketHome extends StatelessWidget {
  const WorketHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WorketHomeStateful();
  }
}

class _WorketHomeStateful extends StatefulWidget {
  const _WorketHomeStateful();

  @override
  State<_WorketHomeStateful> createState() => _WorketHomeStatefulState();
}

class _WorketHomeStatefulState extends State<_WorketHomeStateful> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Center(child: Text('Inicio')),
    const Center(child: SolicitudesWorkScreen()),
    const Center(child: Text('Postulaciones')),
    Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Work Home")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
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

class Perfil extends ConsumerWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(authNotifierProvider.notifier).logout();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text("Cerrar sesion"),
        ),
      ),
    );
  }
}

class SolicitudesWorkScreen extends ConsumerWidget {
  const SolicitudesWorkScreen({super.key});

  String _formatTime(DateTime dateCreated) {
    final now = DateTime.now();
    final difference = now.difference(dateCreated);

    if (difference.inSeconds < 60) return 'Hace un momento';
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"}';
    }
    if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"}';
    }
    if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? "día" : "días"}';
    }
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? "semana" : "semanas"}';
    }
    final months = (difference.inDays / 30).floor();
    return 'Hace $months ${months == 1 ? "mes" : "meses"}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestNotifierProvider);

    return state.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No hay solicitudes disponibles',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(requestNotifierProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final request = data[index];
              return RequestCard(
                status: request.status,
                title: request.title,
                description: request.details,
                time: _formatTime(request.dateCreated),
                onPress: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Postulacion")));
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ocurrió un error al cargar las solicitudes',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(requestNotifierProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
