import 'dart:io';

abstract final class ApiConfig {
  static const _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_definedBaseUrl.isNotEmpty) {
      return _definedBaseUrl;
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001/api';
    }

    return 'http://localhost:3001/api';
  }

  static String get backendBaseUrl {
    final uri = Uri.parse(baseUrl);
    final path = uri.path.endsWith('/api')
        ? uri.path.substring(0, uri.path.length - 4)
        : uri.path;
    return uri.replace(path: path).toString();
  }

  static String audioUrl(String fileName) {
    return Uri.parse(backendBaseUrl).resolve('/audio/$fileName').toString();
  }
}
