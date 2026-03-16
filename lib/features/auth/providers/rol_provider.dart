import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TipoRol { cliente, trabajador }

final rolSeleccionadoProvider = StateProvider<TipoRol?>((ref) => null);
