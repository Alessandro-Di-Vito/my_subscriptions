import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/loader/loader.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/error_banner_service.dart';
import 'package:my_subscriptions/services/loading_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/theme/app_theme.dart';

class MySubscriptionsApp extends StatelessWidget {
  const MySubscriptionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessengerKey = getIt.isRegistered<ErrorBannerService>()
        ? getIt<ErrorBannerService>().messengerKey
        : null;

    return ListenableBuilder(
      listenable: Listenable.merge([
        getIt<LoadingService>(),
        getIt<ThemeCubit>(),
      ]),
      builder: (context, _) {
        final isLoading = getIt<LoadingService>().isLoading;
        final themeMode = getIt<ThemeCubit>().mode;

        return MaterialApp.router(
          title: 'MySubscriptions',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: appRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          builder: (context, child) {
            return Loader(
              isLoading: isLoading,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
