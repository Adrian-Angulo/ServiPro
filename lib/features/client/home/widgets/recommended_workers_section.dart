import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/features/client/home/widgets/recommended_worker_card.dart';

class RecommendedWorkersSection extends StatelessWidget {
  const RecommendedWorkersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trabajadores recomendados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'VER TODOS',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const RecommendedWorkerCard(
          name: 'Carlos Jaramillo',
          specialty: 'Electricista Experto',
          rating: 4.9,
          jobCount: 124,
        ),
        const RecommendedWorkerCard(
          name: 'Marta Rosero',
          specialty: 'Plomería y Hogar',
          rating: 4.8,
          jobCount: 89,
        ),
        const RecommendedWorkerCard(
          name: 'Fernando Ortega',
          specialty: 'Carpintería',
          rating: 4.7,
          jobCount: 67,
        ),
      ],
    );
  }
}
