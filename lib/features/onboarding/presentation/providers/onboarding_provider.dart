import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/onboarding/data/repositories/repository_impl.dart';
import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:servi_pro/features/onboarding/domain/usecases/get_onboarding_usecase.dart';
import 'package:servi_pro/features/onboarding/domain/usecases/set_onboarding_usecase.dart';

// Provider para el repositorio
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (_) => OnboardingRepositoryImpl(),
);

// Provider para GetOnboardingUsecase
final getOnboardingProvider = Provider((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingUsecase(repository: repo);
});

// Provider para SetOnboardingUsecase
final setOnboardingProvider = Provider((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return SetOnboardingUsecase(repository: repo);
});

final onboardingLocal = AsyncNotifierProvider<OnboardingNotifierLocal, bool?>(
  OnboardingNotifierLocal.new,
);

class OnboardingNotifierLocal extends AsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() async {
    return await getOnboarding();
  }

  Future<bool?> getOnboarding() async {
    final usecase = ref.read(getOnboardingProvider);
    return await usecase();
  }

  Future<void> setOnboarding(bool value) async {
    state = const AsyncLoading();
    final usecase = ref.read(setOnboardingProvider);
    state = await AsyncValue.guard(() async {
      await usecase(value);
      return value;
    });
  }
}

class OnboardingNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setPage(int page) => state = page;
  void next(int total) {
    if (state < total - 1) state++;
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, int>(
  OnboardingNotifier.new,
);
