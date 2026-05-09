import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:servi_pro/features/auth/presentation/screens/login_screen.dart';

class ProfileWorker extends ConsumerWidget {
  const ProfileWorker();

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
