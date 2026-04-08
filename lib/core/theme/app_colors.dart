import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary ───────────────────────────────────────
  static const Color primary = Color.fromRGBO(49, 155, 148, 1.0); // Teal
  static const Color onPrimary = Color.fromRGBO(255, 255, 255, 1.0);

  // ── Accent ────────────────────────────────────────
  static const Color accent = Color.fromRGBO(242, 113, 39, 1); // Orange
  static const Color onAccent = Color.fromRGBO(255, 255, 255, 1.0);

  // ── Background ────────────────────────────────────
  static const Color background = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color backgroundSoft = Color.fromRGBO(
    247,
    250,
    252,
    1.0,
  ); // Azul muy claro
  static const Color backgroundMuted = Color.fromRGBO(
    210,
    230,
    240,
    1.0,
  ); // Azul claro medio
  static const Color backgroundSubtle = Color.fromRGBO(
    195,
    218,
    235,
    1.0,
  ); // Azul grisáceo
  static const Color onBackground = Color.fromRGBO(33, 33, 33, 1.0);

  // ── Surface ───────────────────────────────────────
  static const Color surface = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color onSurface = Color.fromRGBO(33, 33, 33, 1.0);

  // ── Error ─────────────────────────────────────────
  static const Color error = Color.fromRGBO(176, 0, 32, 1.0);
  static const Color onError = Color.fromRGBO(255, 255, 255, 1.0);

  // ── Neutral / Greys ───────────────────────────────
  static const Color grey100 = Color.fromRGBO(245, 245, 245, 1.0);
  static const Color grey300 = Color.fromRGBO(224, 224, 224, 1.0);
  static const Color grey500 = Color.fromRGBO(158, 158, 158, 1.0);
  static const Color grey700 = Color.fromRGBO(97, 97, 97, 1.0);
  static const Color grey900 = Color.fromRGBO(33, 33, 33, 1.0);

  // ── Transparencias Primary ────────────────────────
  static const Color primaryOverlay10 = Color.fromRGBO(49, 155, 148, 0.1);
  static const Color primaryOverlay25 = Color.fromRGBO(49, 155, 148, 0.25);
  static const Color primaryOverlay50 = Color.fromRGBO(49, 155, 148, 0.5);

  // ── Transparencias Accent ─────────────────────────
  static const Color accentOverlay10 = Color.fromRGBO(235, 110, 35, 0.1);
  static const Color accentOverlay25 = Color.fromRGBO(235, 110, 35, 0.25);
  static const Color accentOverlay50 = Color.fromRGBO(235, 110, 35, 0.5);

  // ── Transparencias Black ──────────────────────────
  static const Color blackOverlay10 = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color blackOverlay25 = Color.fromRGBO(0, 0, 0, 0.25);
  static const Color blackOverlay50 = Color.fromRGBO(0, 0, 0, 0.5);
}
