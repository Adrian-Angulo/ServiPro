import 'package:servi_pro/data/models/cliente.dart';
import 'package:servi_pro/data/models/trabajador.dart';
import 'package:servi_pro/data/models/usuario.dart';

class AppUserFactory {
  static Usuario fromMap(Map<String, dynamic> map) {
    switch (map['rol']) {
      case 'cliente':
        return Cliente.fromMap(map);

      case 'trabajador':
        return Trabajador.fromMap(map);

      default:
        throw Exception('Rol no válido');
    }
  }
}