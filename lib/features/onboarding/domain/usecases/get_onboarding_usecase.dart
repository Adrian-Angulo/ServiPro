import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingUsecase {
  final OnboardingRepository repository;
  GetOnboardingUsecase({required this.repository});

  Future<bool?> call() async {
    return await repository.getOnboarding();
  }
}
