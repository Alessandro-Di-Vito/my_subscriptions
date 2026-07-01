class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.error,
    this.details,
  });

  final String message;
  final int? statusCode;
  final String? error;
  final Object? details;

  @override
  String toString() {
    if (statusCode == null) {
      return message;
    }
    return '[$statusCode] $message';
  }
}
