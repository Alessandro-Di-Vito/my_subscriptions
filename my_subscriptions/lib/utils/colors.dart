import 'package:flutter/material.dart';
import 'package:my_subscriptions/theme/app_palette.dart';

/// Token legacy per schermate non ancora migrate al Theme.
/// In light mode rispecchia il mockup SubTracker.
abstract final class AppColors {
  static const primary = AppPalette.lightPrimary;
  static const primaryDark = AppPalette.lightPrimaryDark;
  static const background = AppPalette.lightBackground;
  static const surface = AppPalette.lightSurface;
  static const textPrimary = AppPalette.lightTextPrimary;
  static const textSecondary = AppPalette.lightTextSecondary;
  static const gray = Color(0xFFF1F5F9);
  static const disabledColor = Color(0xFFE2E8F0);
}

extension HexColor on String {
  Color fromHex() {
    final buffer = StringBuffer();
    final cleanHex = replaceFirst('#', '');

    if (cleanHex.length == 6) {
      buffer.write('FF');
    }

    buffer.write(cleanHex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
