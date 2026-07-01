// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get benvenuto => 'Benvenuto';

  @override
  String get welcomeTitle => 'Benvenuto';

  @override
  String get welcomeSubtitle =>
      'Tieni traccia e gestisci i tuoi abbonamenti in un unico posto.';

  @override
  String get welcomeButton => 'Inizia';

  @override
  String get welcomeLanguage => 'Italiano';

  @override
  String get welcomePrivacyTerms => 'PRIVACY E TERMINI';

  @override
  String get onboardingTrackTitle => 'Tutti i tuoi abbonamenti in un posto';

  @override
  String get onboardingTrackSubtitle =>
      'Aggiungi Netflix, Spotify, palestra e altro. Organizzali per categoria e sappi sempre per cosa stai pagando.';

  @override
  String get onboardingAnalyzeTitle => 'Scopri dove vanno i tuoi soldi';

  @override
  String get onboardingAnalyzeSubtitle =>
      'Controlla spesa mensile e annuale, confronta i costi e individua gli abbonamenti che non usi più.';

  @override
  String get onboardingRemindTitle => 'Non perdere mai un rinnovo';

  @override
  String get onboardingRemindSubtitle =>
      'Ricevi un promemoria prima di ogni rinnovo per disdire in tempo o organizzare la spesa.';

  @override
  String get onboardingContinue => 'Continua';

  @override
  String get onboardingFinish => 'Inizia';

  @override
  String get onboardingBack => 'Indietro';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Passo $current di $total';
  }
}
