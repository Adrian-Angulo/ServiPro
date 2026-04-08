import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RequestFilterType {
  todos('Todos'),
  pendiente('Pendiente'),
  enProgreso('En progreso'),
  completado('Completado'),
  cancelado('Cancelado');

  final String label;
  const RequestFilterType(this.label);
}

// Provider para el filtro seleccionado
final requestFilterProvider = StateProvider<RequestFilterType>((ref) {
  return RequestFilterType.todos;
});
