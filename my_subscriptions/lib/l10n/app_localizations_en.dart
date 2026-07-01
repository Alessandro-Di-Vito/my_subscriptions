// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get benvenuto => 'Welcome';

  @override
  String get welcomeTitle => 'Welcome';

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
