// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get language => 'Swahili';

  @override
  String get appTitle => 'Utakula!?';

  @override
  String get welcome => 'Karibu';

  @override
  String hello(String name) {
    return 'Habari $name';
  }
}
