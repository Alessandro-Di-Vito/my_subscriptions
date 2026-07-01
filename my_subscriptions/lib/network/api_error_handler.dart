import 'package:dio/dio.dart';
import 'package:my_subscriptions/network/api_exception.dart';


abstract final class ApiErrorHandler {
  static ApiException fromDioException(DioException exception) {
    final response = exception.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        statusCode: _readStatusCode(data, response?.statusCode),
        message: _readMessage(data) ?? _fallbackMessage(exception),
        error: data['error'] as String?,
        details: data,
      );
    }

    if (data is String && data.isNotEmpty) {
      return ApiException(
        statusCode: response?.statusCode,
        message: data,
        details: data,
      );
    }

    return ApiException(
      statusCode: response?.statusCode,
      message: _fallbackMessage(exception),
      details: exception.message,
    );
  }

  static ApiException fromUnknown(Object error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException(message: error.toString(), details: error);
  }

  static int? _readStatusCode(Map<String, dynamic> data, int? fallback) {
    final statusCode = data['statusCode'];
    if (statusCode is int) {
      return statusCode;
    }
    if (statusCode is String) {
      return int.tryParse(statusCode);
    }
    return fallback;
  }

  static String? _readMessage(Map<String, dynamic> data) {
    final message = data['message'];
    if (message is String) {
      return message;
    }
    if (message is List && message.isNotEmpty) {
      return message.join('\n');
    }
    return data['error'] as String?;
  }

  static String _fallbackMessage(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout',
      DioExceptionType.sendTimeout => 'Send timeout',
      DioExceptionType.receiveTimeout => 'Receive timeout',
      DioExceptionType.badCertificate => 'Bad certificate',
      DioExceptionType.badResponse => 'Server error',
      DioExceptionType.cancel => 'Request cancelled',
      DioExceptionType.connectionError => 'Connection error',
      DioExceptionType.transformTimeout => 'Transform timeout',
      DioExceptionType.unknown => 'Unexpected network error',
    };
  }
}
