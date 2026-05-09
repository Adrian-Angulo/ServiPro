import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

class Utils {
   static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFF1E3A5F);
      case 'en progreso':
        return AppColors.accent;
      case 'completado':
        return AppColors.primary;
      case 'cancelado':
        return AppColors.grey500;
      default:
        return const Color(0xFF1E3A5F);
    }
  }

  static IconData getStatusIcon( String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Icons.schedule;
      case 'en progreso':
        return Icons.build;
      case 'completado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }
}