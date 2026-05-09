import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  // Clave usada para guardar el estado del onboarding en SharedPreferences
  static const _key = 'onboarding_complete';

  // Retorna true si el usuario no ha completado el onboarding todavía
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Si la clave no existe, asume que es la primera vez (false por defecto)
  
    return prefs.getBool(_key) ?? false;
  }

  // Marca el onboarding como completado guardando true en SharedPreferences
  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
