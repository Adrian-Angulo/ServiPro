import 'package:servi_pro/data/models/usuario.dart';

class Trabajador extends Usuario {
  String nombreCompleto;
  int edad;
  String ciudad;
  String celular;
  String cedula;
  String sobreMi;

  Trabajador({
    required super.email,
    required super.contrasena,
    required this.nombreCompleto,
    required this.edad,
    required this.ciudad,
    required this.celular,
    required this.cedula,
    required this.sobreMi,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contrasena': contrasena,
      'nombreCompleto': nombreCompleto,
      'edad': edad,
      'ciudad': ciudad,
      'celular': celular,
      'cedula': cedula,
      'sobreMi': sobreMi,
    };
  }

  factory Trabajador.fromJson(Map<String, dynamic> json) {
    return Trabajador(
      email: json['email'],
      contrasena: json['contrasena'],
      nombreCompleto: json['nombreCompleto'],
      edad: json['edad'],
      ciudad: json['ciudad'],
      celular: json['celular'],
      cedula: json['cedula'],
      sobreMi: json['sobreMi'],
    );
  }

  @override
  String toString() {
    return 'Trabajador{email: $email, nombreCompleto: $nombreCompleto, edad: $edad, ciudad: $ciudad, celular: $celular, cedula: $cedula}';
  }
}
