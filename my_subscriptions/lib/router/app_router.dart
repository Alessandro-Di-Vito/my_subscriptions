import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/screens/welcome/welcome_screen.dart';

abstract final class AppRoutes {
  static const welcome = '/';
  static const auth = '/auth';
  static const home = '/home';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const _PlaceholderScreen(title: 'Auth'),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
    ),
  ],
);

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
