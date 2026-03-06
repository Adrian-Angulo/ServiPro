import 'dart:convert';
import 'package:servi_pro/data/models/usuario.dart';

class Cliente extends Usuario {
  final String nombre;
  final int edad;
  final String ciudad;
  final String telefono;
  final String cedula;
  final String numeroTelefono;

  Cliente({
    required this.nombre,
    required this.edad,
    required this.ciudad,
    required super.email,
    required super.contrasena,
    required this.telefono,
    required this.cedula,
    required this.numeroTelefono,
  });
  @override
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
      'ciudad': ciudad,
      'email': email,
      'telefono': telefono,
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nombre: json['nombre'],
      edad: json['edad'],
      ciudad: json['ciudad'],
      email: json['email'],
      contrasena: json['contrasena'] ?? '',
      telefono: json['telefono'],
      cedula: json['cedula'],
      numeroTelefono: json['numeroTelefono'],
    );
  }
}
