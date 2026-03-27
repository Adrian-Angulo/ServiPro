import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

class HomeActionCards extends StatelessWidget {
  const HomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tarjeta naranja - Solicitar servicio
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentOverlay25,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.accessibility_new, color: AppColors.onAccent, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solicitar un servicio',
                        style: TextStyle(
                          color: AppColors.onAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Publica tu necesidad ahora',
                        style: TextStyle(color: AppColors.onAccent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.onAccent, size: 18),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Tarjeta teal - Ver trabajadores
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOverlay25,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.group, color: AppColors.onPrimary, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ver trabajadores\ncercanos',
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Explora el mapa de expertos locales',
                        style: TextStyle(color: AppColors.onPrimary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.onPrimary, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
