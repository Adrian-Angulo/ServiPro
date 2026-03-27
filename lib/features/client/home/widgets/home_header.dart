import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: AppColors.primary, size: 14),
                SizedBox(width: 4),
                Text(
                  'TU UBICACIÓN',
                  style: TextStyle(fontSize: 11, color: AppColors.grey500),
                ),
              ],
            ),
            const Text(
              'Pasto, Nariño',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.grey300,
          child: Icon(Icons.person, color: AppColors.grey700),
        ),
      ],
    );
  }
}
