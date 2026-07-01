import 'package:my_subscriptions/models/user/user_profile.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';
import 'package:my_subscriptions/utils/storage.dart';

class UserService {
  const UserService(this._apiClient);

  final ApiClient _apiClient;

  Future<UserProfile> getProfile({bool showErrorBanner = true}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.userMe,
      showErrorBanner: showErrorBanner,
    );
    return UserProfile.fromJson(response.data!);
  }

  Future<bool> hasCompletedOnboarding({bool showErrorBanner = false}) async {
    try {
      final profile = await getProfile(showErrorBanner: showErrorBanner);
      final completed = profile.preferences?.isOnboardingCompleted ?? false;
      await Storage.setOnboardingCompleted(completed);
      return completed;
    } catch (_) {
      return Storage.getOnboardingCompleted();
    }
  }

  Future<UserPreferences> updatePreferences(
    UserPreferences preferences, {
    bool showErrorBanner = true,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      ApiEndpoints.userPreferences,
      data: preferences.toJson(),
      showErrorBanner: showErrorBanner,
    );
    return UserPreferences.fromJson(response.data!);
  }

  Future<UserPreferences> completeOnboarding({
    bool showErrorBanner = true,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.completeOnboarding,
      showErrorBanner: showErrorBanner,
    );
    await Storage.setOnboardingCompleted(true);
    return UserPreferences.fromJson(response.data!);
  }

  Future<void> syncLocalOnboardingPreferences() async {
    final currency = await Storage.getPreferredCurrency();
    await updatePreferences(
      UserPreferences(
        defaultCurrency: currency,
        notificationsRenewal: false,
        notificationsTrial: false,
      ),
      showErrorBanner: false,
    );
    await completeOnboarding(showErrorBanner: false);
  }

  Future<void> deleteAccount() async {
    await _apiClient.delete<void>(ApiEndpoints.userMe);
    await Storage.clearTokens();
    await Storage.setOnboardingCompleted(false);
  }
}
