import 'package:flutter/material.dart';
import 'package:servi_pro/core/theme/app_typography.dart';


class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.labelMedium);
}