import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_spacing.dart';

class CategoryHelper {
  static Row getIconWithLabel(String category) {
    late String label;
    late IconData icon;

    switch (category.toLowerCase()) {
      case 'plomeria':
        label = 'Plomería';
        icon = Icons.plumbing;
        break;
      case 'electricidad':
        label = 'Electricidad';
        icon = Icons.electric_bolt_rounded;
        break;
      case 'carpinteria':
        label = 'Carpintería';
        icon = Icons.carpenter;
        break;
      case 'limpieza':
        label = 'Limpieza';
        icon = Icons.cleaning_services;
        break;
      case 'pintura':
        label = 'Pintura';
        icon = Icons.format_paint;
        break;
      case 'otro':
        label = 'Otro';
        icon = Icons.miscellaneous_services;
        break;
      default:
        label = category;
        icon = Icons.category;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Color.fromRGBO(100, 116, 139, 1)),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.50,
            letterSpacing: 0.15,
            color: Color.fromRGBO(100, 116, 139, 1),
          ),
        ),
      ],
    );
  }
}
