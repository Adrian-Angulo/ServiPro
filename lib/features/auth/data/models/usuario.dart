enum Rol { cliente, trabajador }

class Usuario {
  final String id;
  final String email;
  final String contrasena;
  final Rol rol;

  Usuario({ required this.email, required this.contrasena, required this.rol, required this.id});
  
}
