import 'package:flutter/material.dart';
import 'package:my_subscriptions/app.dart';
import 'package:my_subscriptions/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MySubscriptionsApp());
}
