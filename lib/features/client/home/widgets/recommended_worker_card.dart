import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

class RecommendedWorkerCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final int jobCount;

  const RecommendedWorkerCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.jobCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.grey300,
            child: Icon(Icons.person, color: AppColors.grey700, size: 28),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: AppColors.primary, size: 14),
                  ],
                ),
                Text(
                  specialty,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                      ),
                    ),
                    Text(
                      '  •  $jobCount trabajos',
                      style: const TextStyle(fontSize: 11, color: AppColors.grey500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Botón chat
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
