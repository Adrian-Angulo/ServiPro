import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';
import 'package:servi_pro/features/application/presentation/providers/application_providers.dart';
import 'package:servi_pro/features/application/presentation/widgets/cards/application_card.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_provider.dart';

class PostulacionesScreen extends ConsumerWidget {
  const PostulacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appliWorker = ref.watch(workerApplicationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Mis postulaciones')),
      backgroundColor: AppColors.backgroundSoft,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: appliWorker.when(
                data: (lista) {
                  if (lista.isEmpty) {
                    return const Center(child: Text('No hay postulaciones'));
                  }
                  return ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final application = lista[index];
                      return ApplicationCard(application: application);
                    },
                  );
                },
                error: (error, stack) => Center(child: Text('Error: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
