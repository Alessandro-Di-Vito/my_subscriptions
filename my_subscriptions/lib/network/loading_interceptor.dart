import 'package:dio/dio.dart';
import 'package:my_subscriptions/services/loading_service.dart';

class LoadingInterceptor extends Interceptor {
  LoadingInterceptor(this._loadingService);

  final LoadingService _loadingService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _loadingService.start();
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _loadingService.stop();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _loadingService.stop();
    handler.next(err);
  }
}
