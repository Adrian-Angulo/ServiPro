import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';

class PerfilCliente extends ConsumerWidget {
  const PerfilCliente({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${user?.email}"),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
            },
            child: Text("Cerrar sesion"),
          ),
        ],
      ),
    );
  }
}
