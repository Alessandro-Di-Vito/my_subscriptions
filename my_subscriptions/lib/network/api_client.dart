import 'package:dio/dio.dart';
import 'package:my_subscriptions/network/api_error_handler.dart';
import 'package:my_subscriptions/network/api_exception.dart';
import 'package:my_subscriptions/services/error_banner_service.dart';

class ApiClient {
  const ApiClient(this._dio, this._errorBannerService);

  final Dio _dio;
  final ErrorBannerService _errorBannerService;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorBanner = true,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleError(
        ApiErrorHandler.fromDioException(error),
        showErrorBanner: showErrorBanner,
      );
    } catch (error) {
      throw _handleError(
        ApiErrorHandler.fromUnknown(error),
        showErrorBanner: showErrorBanner,
      );
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorBanner = true,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleError(
        ApiErrorHandler.fromDioException(error),
        showErrorBanner: showErrorBanner,
      );
    } catch (error) {
      throw _handleError(
        ApiErrorHandler.fromUnknown(error),
        showErrorBanner: showErrorBanner,
      );
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorBanner = true,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleError(
        ApiErrorHandler.fromDioException(error),
        showErrorBanner: showErrorBanner,
      );
    } catch (error) {
      throw _handleError(
        ApiErrorHandler.fromUnknown(error),
        showErrorBanner: showErrorBanner,
      );
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorBanner = true,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleError(
        ApiErrorHandler.fromDioException(error),
        showErrorBanner: showErrorBanner,
      );
    } catch (error) {
      throw _handleError(
        ApiErrorHandler.fromUnknown(error),
        showErrorBanner: showErrorBanner,
      );
    }
  }

  ApiException _handleError(
    ApiException error, {
    required bool showErrorBanner,
  }) {
    if (showErrorBanner) {
      _errorBannerService.showError(error.message);
    }
    return error;
  }
}
