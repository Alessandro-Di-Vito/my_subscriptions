import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/screens/auth/auth_screen.dart';
import 'package:my_subscriptions/screens/auth/auth_state.dart';
import 'package:my_subscriptions/screens/first_subscription/first_subscription_screen.dart';
import 'package:my_subscriptions/screens/home/home_shell_screen.dart';
import 'package:my_subscriptions/screens/onboarding/onboarding_screen.dart';
import 'package:my_subscriptions/screens/subscription/subscription_screens.dart';
import 'package:my_subscriptions/screens/welcome/welcome_screen.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/utils/storage.dart';

abstract final class AppRoutes {
  static const welcome = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const forgotPassword = '/auth/forgot-password';
  static const firstSubscription = '/first-subscription';
  static const home = '/home';
  static const subscriptions = '/subscriptions';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const subscriptionNew = '/subscriptions/new';

  static String subscriptionDetail(String id) => '/subscriptions/$id';
  static String subscriptionEdit(String id) => '/subscriptions/$id/edit';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.welcome,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) {
        final mode = state.uri.queryParameters['mode'] ?? 'login';
        return AuthScreen(
          initialMode: mode == 'register' ? AuthMode.register : AuthMode.login,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.firstSubscription,
      builder: (context, state) => const FirstSubscriptionScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.subscriptions,
              builder: (context, state) => const SubscriptionsTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.analytics,
              builder: (context, state) => const AnalyticsTabScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsTabScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.subscriptionNew,
      builder: (context, state) => const SubscriptionFormScreen(),
    ),
    GoRoute(
      path: '/subscriptions/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SubscriptionDetailScreen(subscriptionId: id);
      },
    ),
    GoRoute(
      path: '/subscriptions/:id/edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SubscriptionFormScreen(subscriptionId: id);
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final location = state.matchedLocation;
  final isLoggedIn = await getIt<AuthService>().isLoggedIn();
  final onboardingCompleted = await Storage.getOnboardingCompleted();

  final isPublicRoute =
      location == AppRoutes.welcome ||
      location == AppRoutes.onboarding ||
      location.startsWith(AppRoutes.auth);

  if (isLoggedIn) {
    if (location == AppRoutes.welcome ||
        location == AppRoutes.onboarding ||
        location == AppRoutes.auth ||
        location == AppRoutes.forgotPassword) {
      return AppRoutes.home;
    }
    return null;
  }

  if (!onboardingCompleted && location != AppRoutes.welcome && !isPublicRoute) {
    return AppRoutes.welcome;
  }

  if (onboardingCompleted &&
      (location == AppRoutes.welcome || location == AppRoutes.onboarding)) {
    return AppRoutes.auth;
  }

  return null;
}
