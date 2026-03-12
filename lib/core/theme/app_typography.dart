import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servi_pro/core/theme/app_colors.dart';

abstract class AppTypography {

  // ── Display ───────────────────────────────────────
  // Uso: Heroes, splash screens, números grandes
  static TextStyle displayLarge = GoogleFonts.nunito(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
    color: AppColors.grey900,
  );

  static TextStyle displayMedium = GoogleFonts.nunito(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  static TextStyle displaySmall = GoogleFonts.nunito(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  // ── Headline ──────────────────────────────────────
  // Uso: Títulos de pantalla, secciones principales
  static TextStyle headlineLarge = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  static TextStyle headlineMedium = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.28,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  static TextStyle headlineSmall = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  // ── Title ─────────────────────────────────────────
  // Uso: AppBar, cards, dialogs, list headers
  static TextStyle titleLarge = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.27,
    letterSpacing: 0,
    color: AppColors.grey900,
  );

  static TextStyle titleMedium = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
    letterSpacing: 0.15,
    color: AppColors.grey900,
  );

  static TextStyle titleSmall = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.42,
    letterSpacing: 0.1,
    color: AppColors.grey900,
  );

  // ── Body ──────────────────────────────────────────
  // Uso: Párrafos, descripciones, contenido principal
  static TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.5,
    color: AppColors.grey900,
  );

  static TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.42,
    letterSpacing: 0.25,
    color: AppColors.grey900,
  );

  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.grey900,
  );

  // ── Label ─────────────────────────────────────────
  // Uso: Botones, chips, tabs, campos de formulario
  static TextStyle labelLarge = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.42,
    letterSpacing: 0.1,
    color: AppColors.grey900,
  );

  static TextStyle labelMedium = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.grey900,
  );

  static TextStyle labelSmall = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.5,
    color: AppColors.grey900,
  );
}