import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) => state = page;
  void next(int total) {
    if (state < total - 1) state++;
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, int>(OnboardingNotifier.new);
