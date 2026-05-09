enum ApplicationStatus {
  postulado,
  aceptado,
  noDisponible,
  finalizado,
}

class ApplicationEntity {
  final String id;
  final String idworker;
  final String idrequest;
  final ApplicationStatus state;


  ApplicationEntity({
    required this.id,
    required this.idworker,
    required this.idrequest,
    required this.state,
  });
}
