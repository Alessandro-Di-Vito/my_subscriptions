import 'package:flutter/material.dart';

/// Token di colore condivisi tra light e dark theme.
abstract final class AppPalette {
  // Light — ispirato al mockup SubTracker (blu rivisto, più morbido)
  static const lightBackground = Color(0xFFF3F6FB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightPrimary = Color(0xFF4B6EF5);
  static const lightPrimaryDark = Color(0xFF3D5BD9);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightHeroStart = Color(0xFF1B2D4A);
  static const lightHeroEnd = Color(0xFF243B63);
  static const lightTextPrimary = Color(0xFF152238);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightOutline = Color(0xFFE2E8F0);
  static const lightSavings = Color(0xFF9B2C3D);
  static const lightPrimaryContainer = Color(0xFFE8EEFF);

  // Dark — charcoal + lime green (mockup subscription tracker)
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSurfaceHigh = Color(0xFF2A2A2A);
  static const darkPrimary = Color(0xFFC8F542);
  static const darkPrimaryGlow = Color(0xFFA8E635);
  static const darkOnPrimary = Color(0xFF121212);
  static const darkTextPrimary = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFF9E9E9E);
  static const darkOutline = Color(0xFF3A3A3A);
  static const darkSavings = Color(0xFFFFB347);
  static const darkPrimaryContainer = Color(0xFF2D3318);
  static const darkChartYellow = Color(0xFFFFD54F);
  static const darkChartOrange = Color(0xFFFF8A50);
}
