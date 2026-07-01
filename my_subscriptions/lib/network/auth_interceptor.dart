import 'package:dio/dio.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';
import 'package:my_subscriptions/utils/storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await Storage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || _shouldSkipRefresh(err.requestOptions)) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      handler.next(err);
      return;
    }

    _isRefreshing = true;
    try {
      final refreshed = await _refreshTokens();
      if (!refreshed) {
        await Storage.clearTokens();
        handler.next(err);
        return;
      }

      final accessToken = await Storage.getAccessToken();
      final request = err.requestOptions;
      request.headers['Authorization'] = 'Bearer $accessToken';
      final response = await _dio.fetch(request);
      handler.resolve(response);
    } catch (_) {
      await Storage.clearTokens();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  bool _shouldSkipRefresh(RequestOptions options) {
    final path = options.path;
    return path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.register) ||
        path.contains(ApiEndpoints.refreshToken);
  }

  Future<bool> _refreshTokens() async {
    final tokenId = await Storage.getTokenId();
    final refreshToken = await Storage.getRefreshToken();
    if (tokenId == null || refreshToken == null) {
      return false;
    }

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refreshToken,
      data: {'tokenId': tokenId, 'refreshToken': refreshToken},
    );

    final data = response.data;
    if (data == null) {
      return false;
    }

    await Storage.setAccessToken(data['accessToken'] as String);
    await Storage.setRefreshToken(data['refreshToken'] as String);
    await Storage.setTokenId(data['tokenId'] as String);
    return true;
  }
}
