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
}
