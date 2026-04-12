import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingUsecase {
  final OnboardingRepository repository;

  SetOnboardingUsecase({required this.repository});

  Future<void> call(bool value) async {
    await repository.setOboarding(value);
  }
}
