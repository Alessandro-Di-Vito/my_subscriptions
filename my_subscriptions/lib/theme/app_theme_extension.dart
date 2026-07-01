import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.savings,
    required this.featuredBorder,
    required this.softAccent,
  });

  final Color heroGradientStart;
  final Color heroGradientEnd;
  final Color savings;
  final Color featuredBorder;
  final Color softAccent;

  @override
  AppThemeExtension copyWith({
    Color? heroGradientStart,
    Color? heroGradientEnd,
    Color? savings,
    Color? featuredBorder,
    Color? softAccent,
  }) {
    return AppThemeExtension(
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      savings: savings ?? this.savings,
      featuredBorder: featuredBorder ?? this.featuredBorder,
      softAccent: softAccent ?? this.softAccent,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      heroGradientStart: Color.lerp(heroGradientStart, other.heroGradientStart, t)!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
      savings: Color.lerp(savings, other.savings, t)!,
      featuredBorder: Color.lerp(featuredBorder, other.featuredBorder, t)!,
      softAccent: Color.lerp(softAccent, other.softAccent, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
