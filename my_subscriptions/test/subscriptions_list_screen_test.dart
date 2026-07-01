import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/screens/subscription/subscriptions_list_screen.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/theme/app_theme.dart';

class _FakeSubscriptionService implements SubscriptionService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<SubscriptionItem>> list({
    String? search,
    String? status,
    String? categoryId,
    String sortBy = 'nextRenewalDate',
    String sortOrder = 'asc',
  }) async {
    return [
      const SubscriptionItem(
        id: '1',
        name: 'Netflix',
        amount: 17.99,
        currency: 'EUR',
        billingCycle: 'MONTHLY',
        nextRenewalDate: '2026-07-15',
        status: 'ACTIVE',
        iconKey: 'netflix',
      ),
    ];
  }
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<SubscriptionService>(_FakeSubscriptionService());
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('subscriptions tab renders list without layout errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SubscriptionsTabScreen(),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Cerca'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
