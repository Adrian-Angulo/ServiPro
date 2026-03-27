import 'package:flutter_riverpod/flutter_riverpod.dart';

// Nombre del cliente (mock por ahora)
final clientNameProvider = StateProvider<String>((ref) => 'Alejandro');

// Índice del bottom nav
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
