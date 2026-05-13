enum ApplicationStatus { postulado, aceptado, noDisponible, finalizado }

class ApplicationEntity {
  final String id;
  final String idworker;
  final String idrequest;
  final ApplicationStatus state;
  final DateTime createdAt;

  ApplicationEntity({
    required this.id,
    required this.idworker,
    required this.idrequest,
    required this.state,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
