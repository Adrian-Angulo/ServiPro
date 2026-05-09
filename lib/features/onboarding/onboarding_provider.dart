import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servi_pro/features/onboarding/onboarding_service.dart';

class OnboardingNotifier extends AsyncNotifier<bool> {
  late final OnboardingService _service;
  @override
  FutureOr<bool> build()async {
    _service = OnboardingService();
    return await _service.hasSeenOnboarding();
  }

  Future<void> completeOnboarding() async {
    await _service.markOnboardingComplete();
    state = AsyncValue.data(true);
  }
}

final onboardingNotifier = AsyncNotifierProvider<OnboardingNotifier, bool>(
  OnboardingNotifier.new,
);
