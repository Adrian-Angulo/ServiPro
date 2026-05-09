import 'package:flutter/material.dart';

class JobBadge extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const JobBadge({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: color,
        ),

        const SizedBox(width: 5),

        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}