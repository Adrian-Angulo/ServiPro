import 'package:servi_pro/features/auth/data/models/usuario.dart';

class Trabajador extends Usuario {
  String nombreCompleto;
  int edad;
  String ciudad;
  String celular;
  String cedula;
  String profesion;
  String sobreMi;

  /// Promedio persistido en Firestore (se sincroniza al crear reseñas).
  double averageRating;

  /// Total de reseñas persistido en Firestore.
  int reviewsCount;

  Trabajador({
    required super.id,
    required super.email,
    required super.contrasena,
    required this.nombreCompleto,
    required this.edad,
    required this.ciudad,
    required this.celular,
    required this.cedula,
    required this.profesion,
    required this.sobreMi,
    required super.rol,
    this.averageRating = 0,
    this.reviewsCount = 0,
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
      'profesion': profesion,
      'rol': rol.name,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
    };
  }

  /// Lee el primer campo no vacío entre varias claves (p. ej. datos legacy o
  /// nombres distintos en Firestore: `Profesion`, `profession`, etc.).
  static String _firstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final raw = map[key];
      if (raw == null) continue;
      final s = raw is String ? raw : raw.toString();
      if (s.trim().isNotEmpty) return s.trim();
    }
    return '';
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
      sobreMi: map['sobreMi'] ?? '',
      profesion: _firstString(map, const [
        'profesion',
        'profesión',
        'Profesion',
        'profession',
        'ocupacion',
        'ocupación',
        'especialidad',
      ]),
      rol: map['rol'] == 'trabajador' ? Rol.trabajador : Rol.cliente,
      averageRating: _parseDouble(map['averageRating']),
      reviewsCount: _parseInt(map['reviewsCount']),
    );
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  @override
  String toString() {
    return 'Trabajador{email: $email, nombreCompleto: $nombreCompleto, edad: $edad, ciudad: $ciudad, celular: $celular, cedula: $cedula, profesion: $profesion}';
  }
}
