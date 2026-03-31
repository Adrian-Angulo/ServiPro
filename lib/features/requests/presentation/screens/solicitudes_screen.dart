import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';

class SolicitudesScreen extends ConsumerWidget {
  const SolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Solicitudes registradas",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: state.when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inbox, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          "La lista está vacía",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final r = data[index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              DialogRoute(
                                context: context,
                                builder: (context) => Detalles(r: r),
                              ),
                            );
                          },
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.build,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                r.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  await ref
                                      .read(requestNotifierProvider.notifier)
                                      .deleteRquest(id: r.id ?? "");
                                },
                                child: Text("Cancelar"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              error: (error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Error: $error",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Detalles extends StatelessWidget {
  const Detalles({super.key, required this.r});

  final RequestModel r;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Detalle de solicitud",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 24,
                      child: Icon(Icons.build, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _InfoRow(
                  icon: Icons.person,
                  label: "Cliente ID",
                  value: r.idClient.toString(),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.miscellaneous_services,
                  label: "Tipo de servicio",
                  value: r.idTypeService.toString(),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.location_on,
                  label: "Dirección",
                  value: r.addres,
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.notes,
                  label: "Detalles",
                  value: r.details,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
