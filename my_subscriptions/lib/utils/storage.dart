import 'package:shared_preferences/shared_preferences.dart';

/// Unico punto di accesso a SharedPreferences.
abstract final class Storage {
  static const _alreadyLaunchKey = 'ALREADY_LAUNCH';
  static const _onboardingCompletedKey = 'ONBOARDING_COMPLETED';
  static const _tokenIdKey = 'TOKEN_ID';
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  // ── Primo avvio ─────────────────────────────────────────────────────────────

  static Future<bool> getAlreadyLaunch() async {
    final prefs = await _prefs();
    return prefs.getBool(_alreadyLaunchKey) ?? false;
  }

  static Future<void> setAlreadyLaunch(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_alreadyLaunchKey, value);
  }

  static Future<bool> getOnboardingCompleted() async {
    final prefs = await _prefs();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_onboardingCompletedKey, value);
  }

  static const _preferredCurrencyKey = 'PREFERRED_CURRENCY';
  static const _notificationsEnabledKey = 'NOTIFICATIONS_ENABLED';

  static Future<String> getPreferredCurrency() async {
    final prefs = await _prefs();
    return prefs.getString(_preferredCurrencyKey) ?? 'EUR';
  }

  static Future<void> setPreferredCurrency(String value) async {
    final prefs = await _prefs();
    await prefs.setString(_preferredCurrencyKey, value);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await _prefs();
    return prefs.getBool(_notificationsEnabledKey) ?? false;
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_notificationsEnabledKey, value);
  }

  static const _notificationsPermissionAskedKey =
      'NOTIFICATIONS_PERMISSION_ASKED';

  static Future<bool> getNotificationsPermissionAsked() async {
    final prefs = await _prefs();
    return prefs.getBool(_notificationsPermissionAskedKey) ?? false;
  }

  static Future<void> setNotificationsPermissionAsked(bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(_notificationsPermissionAskedKey, value);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await _prefs();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getTokenId() async {
    final prefs = await _prefs();
    return prefs.getString(_tokenIdKey);
  }

  static Future<void> setTokenId(String value) async {
    final prefs = await _prefs();
    await prefs.setString(_tokenIdKey, value);
  }

  static Future<void> setAccessToken(String value) async {
    final prefs = await _prefs();
    await prefs.setString(_accessTokenKey, value);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _prefs();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> setRefreshToken(String value) async {
    final prefs = await _prefs();
    await prefs.setString(_refreshTokenKey, value);
  }

  static Future<void> clearTokens() async {
    final prefs = await _prefs();
    await prefs.remove(_tokenIdKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
