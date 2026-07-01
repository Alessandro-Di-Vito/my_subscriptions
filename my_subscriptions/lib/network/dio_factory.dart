import 'package:dio/dio.dart';
import 'package:my_subscriptions/network/api_config.dart';
import 'package:my_subscriptions/network/auth_interceptor.dart';
import 'package:my_subscriptions/network/loading_interceptor.dart';
import 'package:my_subscriptions/services/loading_service.dart';

abstract final class DioFactory {
  static Dio? _dio;

  static Dio create({required LoadingService loadingService}) {
    if (_dio != null) {
      return _dio!;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(LoadingInterceptor(loadingService));
    _dio = dio;
    return dio;
  }
}
