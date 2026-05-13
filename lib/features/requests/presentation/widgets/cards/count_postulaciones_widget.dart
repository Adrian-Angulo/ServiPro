import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:servi_pro/core/theme/app_typography.dart';
import 'package:servi_pro/features/requests/domain/entities/request_entity.dart';

class CountPostulacionesWidget extends StatelessWidget {
  final RequestEntity request;
  const CountPostulacionesWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final countP = request.postulationsCount;
    final hasPostulations = countP > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          hasPostulations ? Icons.people_alt_outlined : Icons.inbox_outlined,
          size: 16,
          color: hasPostulations ? const Color(0xFF1E3A5F) : Colors.grey,
        ),

        const SizedBox(width: 4),

        Text(
          hasPostulations
              ? '$countP ${countP == 1 ? 'postulación' : 'postulaciones'}'
              : 'Sin postulaciones aún',
          style: AppTypography.bodyMedium.copyWith(
            color: hasPostulations
                ? const Color(0xFF1E3A5F)
                : AppColors.grey700,
            fontWeight: hasPostulations ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
