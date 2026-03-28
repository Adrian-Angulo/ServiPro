// Modelo que representa una solicitud de servicio del cliente
class Solicitud {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String zona;
  final String barrio; // Ej: "Barrio La Cocha"
  final EstadoSolicitud estado;
  final DateTime fechaCreacion;
  final List<Postulacion> postulaciones;

  const Solicitud({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.zona,
    this.barrio = '',
    required this.estado,
    required this.fechaCreacion,
    this.postulaciones = const [],
  });
}

// Modelo de un trabajador que se postula a una solicitud
class Postulacion {
  final String id;
  final String nombreTrabajador;
  final String especialidad;
  final double calificacion;
  final int trabajosRealizados;
  final String telefonoWhatsapp;

  const Postulacion({
    required this.id,
    required this.nombreTrabajador,
    required this.especialidad,
    required this.calificacion,
    required this.trabajosRealizados,
    required this.telefonoWhatsapp,
  });
}

// Los posibles estados de una solicitud
enum EstadoSolicitud {
  pendiente,
  enCurso,
  finalizada,
  cancelada,
}

// Función de ayuda para convertir el enum a texto legible
extension EstadoSolicitudExtension on EstadoSolicitud {
  String get nombre {
    switch (this) {
      case EstadoSolicitud.pendiente:
        return 'PENDIENTE';
      case EstadoSolicitud.enCurso:
        return 'EN CURSO';
      case EstadoSolicitud.finalizada:
        return 'FINALIZADA';
      case EstadoSolicitud.cancelada:
        return 'CANCELADA';
    }
  }
}
