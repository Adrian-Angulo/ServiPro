import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RequestFilterType { todos, pending, inProgress, completed, cancelled }

// Provider para el filtro seleccionado
final requestFilterProvider = StateProvider<RequestFilterType>((ref) {
  return RequestFilterType.todos;
});
