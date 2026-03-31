import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
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
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      /* appBar: AppBar(
        title: const Text(
          "Crear solicitud",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ), */
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nueva solicitud",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final r = RequestModel(
                            title: "Fuga de agua",
                            idClient: "afadsfasdf",
                            idTypeService: 1,
                            details: "Cual quier detalle",
                            addres: "Las mecerdes",
                          );
                          ref
                              .read(requestNotifierProvider.notifier)
                              .registerRequest(r: r);
                        },
                        icon: const Icon(Icons.send),
                        label: const Text("Enviar solicitud"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}

