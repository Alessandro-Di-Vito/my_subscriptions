import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/loader/loader.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/error_banner_service.dart';
import 'package:my_subscriptions/services/loading_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';

class MySubscriptionsApp extends StatelessWidget {
  const MySubscriptionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessengerKey = getIt.isRegistered<ErrorBannerService>()
        ? getIt<ErrorBannerService>().messengerKey
        : null;

    return ListenableBuilder(
      listenable: getIt<LoadingService>(),
      builder: (context, _) {
        final isLoading = getIt<LoadingService>().isLoading;

        return MaterialApp.router(
          title: 'My Subscriptions',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: appRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF63A375)),
            useMaterial3: true,
          ),
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
