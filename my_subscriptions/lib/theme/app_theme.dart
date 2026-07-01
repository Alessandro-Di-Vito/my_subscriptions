import 'package:flutter/material.dart';
import 'package:my_subscriptions/theme/app_palette.dart';
import 'package:my_subscriptions/theme/app_theme_extension.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.lightPrimary,
      onPrimary: AppPalette.lightOnPrimary,
      primaryContainer: AppPalette.lightPrimaryContainer,
      onPrimaryContainer: AppPalette.lightHeroStart,
      secondary: AppPalette.lightPrimaryDark,
      onSecondary: AppPalette.lightOnPrimary,
      surface: AppPalette.lightSurface,
      onSurface: AppPalette.lightTextPrimary,
      onSurfaceVariant: AppPalette.lightTextSecondary,
      outline: AppPalette.lightOutline,
      outlineVariant: Color(0xFFE8EDF5),
      error: Color(0xFFDC2626),
      onError: Colors.white,
      surfaceContainerHighest: Color(0xFFF1F5F9),
      surfaceContainerHigh: Color(0xFFF8FAFC),
    );

    return _base(
      scheme: scheme,
      scaffoldBackground: AppPalette.lightBackground,
      appBarBackground: AppPalette.lightBackground,
      extension: const AppThemeExtension(
        heroGradientStart: AppPalette.lightHeroStart,
        heroGradientEnd: AppPalette.lightHeroEnd,
        savings: AppPalette.lightSavings,
        featuredBorder: AppPalette.lightPrimary,
        softAccent: AppPalette.lightPrimaryContainer,
      ),
      inputFill: const Color(0xFFF8FAFC),
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.darkPrimary,
      onPrimary: AppPalette.darkOnPrimary,
      primaryContainer: AppPalette.darkPrimaryContainer,
      onPrimaryContainer: Color(0xFFE8F5C8),
      secondary: AppPalette.darkChartYellow,
      onSecondary: AppPalette.darkOnPrimary,
      surface: AppPalette.darkSurface,
      onSurface: AppPalette.darkTextPrimary,
      onSurfaceVariant: AppPalette.darkTextSecondary,
      outline: AppPalette.darkOutline,
      outlineVariant: Color(0xFF333333),
      error: Color(0xFFFF6B6B),
      onError: Colors.white,
      surfaceContainerHighest: AppPalette.darkSurfaceHigh,
      surfaceContainerHigh: Color(0xFF232323),
    );

    return _base(
      scheme: scheme,
      scaffoldBackground: AppPalette.darkBackground,
      appBarBackground: AppPalette.darkBackground,
      extension: const AppThemeExtension(
        heroGradientStart: Color(0xFF1A1A1A),
        heroGradientEnd: Color(0xFF2A3218),
        savings: AppPalette.darkSavings,
        featuredBorder: AppPalette.darkPrimary,
        softAccent: AppPalette.darkPrimaryContainer,
      ),
      inputFill: AppPalette.darkSurfaceHigh,
    );
  }

  static ThemeData _base({
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required Color appBarBackground,
    required AppThemeExtension extension,
    required Color inputFill,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      extensions: [extension],
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothStyle.borderRadius,
          smoothness: SmoothStyle.smoothness,
          side: BorderSide(
            color: scheme.outline.withValues(
              alpha: scheme.brightness == Brightness.dark ? 0.35 : 1,
            ),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 52),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothStyle.borderRadius,
            smoothness: SmoothStyle.smoothness,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return scheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return scheme.outline;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            SmoothRectangleBorder(
              borderRadius: SmoothStyle.borderRadius,
              smoothness: SmoothStyle.smoothness,
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return scheme.onPrimaryContainer;
            }
            return scheme.onSurface;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return scheme.primaryContainer;
            }
            return scheme.surface;
          }),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: scheme.onSurface),
        bodyMedium: TextStyle(color: scheme.onSurfaceVariant),
        labelLarge: TextStyle(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
