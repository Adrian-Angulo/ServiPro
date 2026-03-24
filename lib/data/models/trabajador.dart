import 'package:servi_pro/data/models/usuario.dart';

class Trabajador extends Usuario {
  String nombreCompleto;
  int edad;
  String ciudad;
  String celular;
  String cedula;
  String sobreMi;

  Trabajador({
    required super.id,
    required super.email,
    required super.contrasena,
    required this.nombreCompleto,
    required this.edad,
    required this.ciudad,
    required this.celular,
    required this.cedula,
    required this.sobreMi,
    required super.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'contrasena': contrasena,
      'nombreCompleto': nombreCompleto,
      'edad': edad,
      'ciudad': ciudad,
      'celular': celular,
      'cedula': cedula,
      'sobreMi': sobreMi,
      'rol': rol.name
    };
  }

  factory Trabajador.fromMap(Map<String, dynamic> map) {
    return Trabajador(
      id: map['id'],
      email: map['email'],
      contrasena: map['contrasena'],
      nombreCompleto: map['nombreCompleto'],
      edad: map['edad'],
      ciudad: map['ciudad'],
      celular: map['celular'],
      cedula: map['cedula'],
      sobreMi: map['sobreMi'],
      rol: map['rol'] == 'trabajador' ? Rol.trabajador : Rol.cliente,
    );
  }

  @override
  String toString() {
    return 'Trabajador{email: $email, nombreCompleto: $nombreCompleto, edad: $edad, ciudad: $ciudad, celular: $celular, cedula: $cedula}';
  }
}
