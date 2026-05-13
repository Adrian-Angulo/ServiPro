
import 'package:flutter/material.dart';
import 'package:servi_pro/core/utils/enums.dart';

class StatusBadge extends StatelessWidget {
  final ServiceStatus status;

  const StatusBadge({super.key, required this.status});

  Color get backgroundColor {
    switch (status) {
      case ServiceStatus.pending:
        return const Color(0xFFFFF4DB);

      case ServiceStatus.inProgress:
        return const Color(0xFFE8F7FF);

      case ServiceStatus.completed:
        return const Color(0xFFEAFBF1);

      case ServiceStatus.cancelled:
        return const Color(0xFFFFEAEA);
      case ServiceStatus.awaitingConfirmation:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Color get contentColor {
    switch (status) {
      case ServiceStatus.pending:
        return const Color(0xFFD98C1F);

      case ServiceStatus.inProgress:
        return const Color(0xFF2196F3);

      case ServiceStatus.completed:
        return const Color(0xFF22A45D);

      case ServiceStatus.cancelled:
        return const Color(0xFFE53935);
      case ServiceStatus.awaitingConfirmation:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  IconData get icon {
    switch (status) {
      case ServiceStatus.pending:
        return Icons.access_time_rounded;

      case ServiceStatus.inProgress:
        return Icons.sync_rounded;

      case ServiceStatus.completed:
        return Icons.check_circle_rounded;

      case ServiceStatus.cancelled:
        return Icons.cancel_rounded;
      case ServiceStatus.awaitingConfirmation:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String get text {
    switch (status) {
      case ServiceStatus.pending:
        return 'Pendiente';

      case ServiceStatus.inProgress:
        return 'En proceso';

      case ServiceStatus.completed:
        return 'Finalizado';

      case ServiceStatus.cancelled:
        return 'Cancelado';
      case ServiceStatus.awaitingConfirmation:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: contentColor),

          const SizedBox(width: 8),

          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
