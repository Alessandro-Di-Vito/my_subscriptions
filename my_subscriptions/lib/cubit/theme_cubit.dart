import 'package:flutter/material.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

class ThemeCubit extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    if (!await getIt<AuthService>().isLoggedIn()) {
      _mode = ThemeMode.system;
      notifyListeners();
      return;
    }

    try {
      final prefs = await getIt<UserService>().getPreferences(showErrorBanner: false);
      _mode = mapApiTheme(prefs.theme);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setTheme(String apiTheme) async {
    final prefs = await getIt<UserService>().getPreferences();
    final updated = await getIt<UserService>().updatePreferences(
      prefs.copyWith(theme: apiTheme),
    );
    _mode = mapApiTheme(updated.theme);
    notifyListeners();
  }

  void reset() {
    _mode = ThemeMode.system;
    notifyListeners();
  }

  static ThemeMode mapApiTheme(String? theme) {
    return switch (theme) {
      'LIGHT' => ThemeMode.light,
      'DARK' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String apiFromThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'LIGHT',
      ThemeMode.dark => 'DARK',
      ThemeMode.system => 'SYSTEM',
    };
  }
}
