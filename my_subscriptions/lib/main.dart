import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_subscriptions/app.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('it_IT', null);
  await setupServiceLocator();

  if (await getIt<AuthService>().isLoggedIn()) {
    await getIt<ThemeCubit>().load();
  }

  runApp(const MySubscriptionsApp());
}
