import 'package:flutter/widgets.dart';
import 'package:quokka_mobile_app/app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const AppLocalizationsDelegate();

  static List<Locale> get supportedLocales {
    // Include all of your supported language codes here
    return const [Locale('en')];
  }

  @override
  bool isSupported(Locale locale) {
    List<String> localesToString =
        supportedLocales.map((locale) => locale.languageCode).toList();

    // Include all of your supported language codes here
    return localesToString.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
