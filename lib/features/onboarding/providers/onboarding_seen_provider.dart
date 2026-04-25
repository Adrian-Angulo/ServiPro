import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(),
);

/// true = primera vez (mostrar onboarding), false = ya lo vio (ir al login)
final isFirstLaunchProvider = FutureProvider<bool>((ref) {
  final repo = ref.read(onboardingRepositoryProvider);
  return repo.isFirstLaunch();
});
