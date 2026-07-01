import 'package:flutter_test/flutter_test.dart';
import 'package:my_subscriptions/app.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await setupServiceLocator();
  });

  testWidgets('shows welcome screen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const MySubscriptionsApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));

    expect(find.text('MySubscriptions'), findsWidgets);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('welcome navigates to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const MySubscriptionsApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('All your subscriptions in one place'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
