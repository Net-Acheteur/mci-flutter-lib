part of 'current_localization_delegate_abstract.dart';

class BaseCurrentLocalizationDelegate extends CurrentLocalizationDelegateAbstract {
  BaseCurrentLocalizationDelegate({Locale? locale}) {
    initLocale(locale: locale);
  }

  initLocale({Locale? locale}) async {
    currentLocale = locale ?? Locale((await findSystemLocale()).substring(0, 2));
  }

  @override
  set currentLocale(Locale l) {
    locale = l;
  }

  @override
  get currentLocalizationDelegate {
    return appLocalizations;
  }
}
