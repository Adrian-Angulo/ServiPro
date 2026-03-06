class Usuario {
  String _email;
  String _contrasena;

  Usuario({required String email, required String contrasena})
    : _email = email,
      _contrasena = contrasena;

  // Getters
  String get email => _email;
  String get contrasena => _contrasena;

  // Setters
  set email(String email) => _email = email;
  set contrasena(String contrasena) => _contrasena = contrasena;

  // toMap
  Map<String, dynamic> toMap() {
    return {'email': _email, 'contrasena': _contrasena};
  }

  // fromJson
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json['email'] ?? '',
      contrasena: json['contrasena'] ?? '',
    );
  }

  // toJson (opcional, útil para serialización)
  Map<String, dynamic> toJson() => toMap();
}
