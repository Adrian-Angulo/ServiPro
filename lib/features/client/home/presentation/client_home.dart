import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientHome extends ConsumerWidget {
  const ClientHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Client Home"),),
      body: Center(child: ElevatedButton(
            onPressed: () {
              
            },
            child: const Text("Enviar solicitud"),
          ), ),
    );
  }
}