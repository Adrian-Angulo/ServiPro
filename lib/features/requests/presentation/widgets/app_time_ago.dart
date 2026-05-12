import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class AppTimeAgo extends StatelessWidget {
  final DateTime date;

  const AppTimeAgo({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Timeago(
      locale: 'es',
      date: date,

      builder: (context, value) => Text(
        value,
        style: GoogleFonts.nunito(
          fontSize: 14,
          height: 1.42,
          letterSpacing: 0.1,
          color: AppColors.grey700,
        ),
      ),
    );
  }
}
