import 'package:servi_pro/data/models/usuario.dart';

class Cliente extends Usuario {
  final String nombre;
  final String edad;
  final String ciudad;
  final String cedula;
  final String telefono;

  Cliente({
    required super.id,
    required this.nombre,
    required this.edad,
    required this.ciudad,
    required super.email,
    required super.contrasena,
    required this.cedula,
    required this.telefono,
    required super.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'edad': edad,
      'ciudad': ciudad,
      'cedula': cedula,
      'telefono': telefono,
      'rol': rol,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
      edad: map['edad'],
      ciudad: map['ciudad'],
      email: map['email'],
      contrasena: map['contrasena'] ?? '',
      cedula: map['cedula'],
      telefono: map['telefono'],
      rol: map['rol'] == 'cliente' ? Rol.cliente : Rol.trabajador,
    );
  }
}
