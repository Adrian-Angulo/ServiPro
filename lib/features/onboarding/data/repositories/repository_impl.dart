import 'package:servi_pro/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  static const String _isSeeOnboarding = "isSeeOnboarding";

 

  @override
  Future<bool?> getOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return preferences.getBool(_isSeeOnboarding);
    } catch (e) {
      throw Exception("error al obtener el valor");
    }
  }

  @override
  Future<void> setOboarding(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    try {
      await preferences.setBool(_isSeeOnboarding, true);
    } catch (e) {
      throw Exception("Error al guardar el onboarding");
    }
  }
}
