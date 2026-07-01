import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/dio_factory.dart';
import 'package:my_subscriptions/services/error_banner_service.dart';
import 'package:my_subscriptions/services/user_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (getIt.isRegistered<ErrorBannerService>()) {
    return;
  }

  getIt.registerLazySingleton<ErrorBannerService>(ErrorBannerService.new);
  getIt.registerLazySingleton<Dio>(DioFactory.create);
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>(), getIt<ErrorBannerService>()),
  );
  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt<ApiClient>()),
  );
}
