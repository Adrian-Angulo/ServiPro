import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistroTrabajadorState {
  final String nombreCompleto;
  final String edad;
  final String ciudad;
  final String correo;
  final String celular;
  final String cedula;
  final String sobreMi;

  const RegistroTrabajadorState({
    this.nombreCompleto = '',
    this.edad = '',
    this.ciudad = '',
    this.correo = '',
    this.celular = '',
    this.cedula = '',
    this.sobreMi = '',
  });

  RegistroTrabajadorState copyWith({
    String? nombreCompleto,
    String? edad,
    String? ciudad,
    String? correo,
    String? celular,
    String? cedula,
    String? sobreMi,
  }) {
    return RegistroTrabajadorState(
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      edad: edad ?? this.edad,
      ciudad: ciudad ?? this.ciudad,
      correo: correo ?? this.correo,
      celular: celular ?? this.celular,
      cedula: cedula ?? this.cedula,
      sobreMi: sobreMi ?? this.sobreMi,
    );
  }

  bool get isValid =>
      nombreCompleto.isNotEmpty &&
      edad.isNotEmpty &&
      ciudad.isNotEmpty &&
      correo.isNotEmpty &&
      celular.isNotEmpty &&
      cedula.isNotEmpty;
}

class RegistroTrabajadorNotifier extends StateNotifier<RegistroTrabajadorState> {
  RegistroTrabajadorNotifier() : super(const RegistroTrabajadorState());

  void update({
    String? nombreCompleto,
    String? edad,
    String? ciudad,
    String? correo,
    String? celular,
    String? cedula,
    String? sobreMi,
  }) {
    state = state.copyWith(
      nombreCompleto: nombreCompleto,
      edad: edad,
      ciudad: ciudad,
      correo: correo,
      celular: celular,
      cedula: cedula,
      sobreMi: sobreMi,
    );
  }
}

final registroTrabajadorProvider =
    StateNotifierProvider<RegistroTrabajadorNotifier, RegistroTrabajadorState>(
  (ref) => RegistroTrabajadorNotifier(),
);
