import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/dio_factory.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/services/analytics_service.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/category_service.dart';
import 'package:my_subscriptions/services/error_banner_service.dart';
import 'package:my_subscriptions/services/loading_service.dart';
import 'package:my_subscriptions/services/local_notification_service.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/services/user_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (getIt.isRegistered<ErrorBannerService>()) {
    return;
  }

  getIt.registerLazySingleton<LoadingService>(LoadingService.new);
  getIt.registerLazySingleton<ErrorBannerService>(ErrorBannerService.new);
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(loadingService: getIt<LoadingService>()),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>(), getIt<ErrorBannerService>()),
  );
  getIt.registerLazySingleton<ThemeCubit>(ThemeCubit.new);
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<UserService>(
    () => UserService(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<CategoryService>(
    () => CategoryService(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<SubscriptionService>(
    () => SubscriptionService(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<LocalNotificationService>(
    LocalNotificationService.new,
  );

  await getIt<LocalNotificationService>().initialize();
}
