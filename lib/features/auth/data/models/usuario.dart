import 'package:servi_pro/core/domain/enums/rol.dart';

export 'package:servi_pro/core/domain/enums/rol.dart';

class Usuario {
  final String id;
  final String email;
  final String contrasena;
  final Rol rol;

  Usuario({
    required this.id,
    required this.email,
    required this.contrasena,
    required this.rol,
  });
}
