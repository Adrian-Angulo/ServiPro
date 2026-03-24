import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/auth/data/models/usuario.dart';
import 'package:servi_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:servi_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:servi_pro/features/auth/presentation/providers/auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, Usuario?>(
  () => AuthNotifier(),
);
