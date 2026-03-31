import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';

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
  final List<Widget> _pages = const [
    Center(child: Text('Inicio')),
    Center(child: SolicitudesWorkScreen()),
    Center(child: Text('Postulaciones')),
    Center(child: Text('Perfil')),
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

class SolicitudesWorkScreen extends ConsumerWidget {
  const SolicitudesWorkScreen({super.key});

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
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.work_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    request.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.details,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.addres,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: navegar al detalle o postularse
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Postularme'),
                  ),
                ),
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
