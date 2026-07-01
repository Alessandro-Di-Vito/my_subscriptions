// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MySubscriptions';

  @override
  String get appTagline => 'Master your digital subscriptions.';

  @override
  String get benvenuto => 'Welcome';

  @override
  String get welcomeTitle => 'MySubscriptions';

  @override
  String get welcomeSubtitle =>
      'Track and manage your subscriptions in one place.';

  @override
  String get welcomeButton => 'Get started';

  @override
  String get welcomeLanguage => 'English';

  @override
  String get welcomePrivacyTerms => 'PRIVACY & TERMS';

  @override
  String get emptyNoSubscriptions => 'No subscriptions yet';

  @override
  String get emptyNoSubscriptionsSubtitle =>
      'Add your first service to start tracking renewals and spending.';

  @override
  String get emptyNoUpcoming => 'Nothing due soon';

  @override
  String get emptyNoUpcomingSubtitle =>
      'You\'re all set for now. We\'ll show the next renewal here.';

  @override
  String get emptyNoActive => 'No active subscriptions';

  @override
  String get emptyNoAnalytics => 'Not enough data yet';

  @override
  String get emptyNoAnalyticsSubtitle =>
      'Add subscriptions to see charts and insights.';

  @override
  String get emptyNoSearchResults => 'No services found';

  @override
  String get emptyNoRenewals => 'No renewal history';

  @override
  String get addSubscription => 'Add subscription';

  @override
  String get onboardingTrackTitle => 'All your subscriptions in one place';

  @override
  String get onboardingTrackSubtitle =>
      'Add Netflix, Spotify, gym and more. Organize them by category and always know what you are paying for.';

  @override
  String get onboardingAnalyzeTitle => 'See where your money goes';

  @override
  String get onboardingAnalyzeSubtitle =>
      'Check your monthly and yearly spending, compare costs and spot subscriptions you no longer use.';

  @override
  String get onboardingRemindTitle => 'Never miss a renewal';

  @override
  String get onboardingRemindSubtitle =>
      'Get a reminder before each renewal so you can cancel in time or budget for the expense.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingFinish => 'Get started';

  @override
  String get onboardingBack => 'Back';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Step $current of $total';
  }
}
