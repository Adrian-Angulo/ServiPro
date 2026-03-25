import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/requests/data/models/request_model.dart';
import 'package:servi_pro/features/requests/presentation/providers/request_notifier.dart';

class RegisterRequestScreen extends ConsumerStatefulWidget {
  const RegisterRequestScreen({super.key});

  @override
  ConsumerState<RegisterRequestScreen> createState() =>
      _RegisterRequestScreenState();
}

class _RegisterRequestScreenState extends ConsumerState<RegisterRequestScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Crear solicitud")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final r = RequestModel(
                id: 1,
                idClient: 2,
                idTypeService: 1,
                details: "Cual quier detalle",
                addres: "Las mecerdes",
              );
              ref.read(requestNotifierProvider.notifier).registerRequest(r: r);
            },
            child: const Text("Enviar solicitud"),
          ),
          Expanded(
            child: state.when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(child: Text("La lista esta vacia"));
                } else {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final r = data[index];
                      return Text(r.details);
                    },
                  );
                }
              },
              error: (error, stackTrace) {
                return Center(child: Text("Error: $error"));
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
