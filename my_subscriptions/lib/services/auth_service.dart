import 'package:my_subscriptions/models/auth/auth_session.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';
import 'package:my_subscriptions/utils/storage.dart';

class AuthService {
  const AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email.trim(), 'password': password},
      showErrorBanner: true,
    );
    final session = AuthSession.fromJson(response.data!);
    await _persistSession(session);
    return session;
  }

  Future<AuthSession> register({
    required String email,
    required String password,
    String? displayName,
    String? defaultCurrency,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'email': email.trim(),
        'password': password,
        if (displayName != null && displayName.isNotEmpty)
          'displayName': displayName,
        if (defaultCurrency != null) 'defaultCurrency': defaultCurrency,
      },
    );
    final session = AuthSession.fromJson(response.data!);
    await _persistSession(session);
    return session;
  }

  Future<void> logout() async {
    final tokenId = await Storage.getTokenId();
    try {
      await _apiClient.post<void>(
        ApiEndpoints.logout,
        data: tokenId != null ? {'tokenId': tokenId} : null,
        showErrorBanner: false,
      );
    } catch (_) {
      // Clear local session even if remote logout fails.
    }
    await Storage.clearTokens();
  }

  Future<void> forgotPassword(String email) async {
    await _apiClient.post<void>(
      ApiEndpoints.forgotPassword,
      data: {'email': email.trim()},
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await Storage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _persistSession(AuthSession session) async {
    await Storage.setAccessToken(session.accessToken);
    await Storage.setRefreshToken(session.refreshToken);
    await Storage.setTokenId(session.tokenId);
  }
}
