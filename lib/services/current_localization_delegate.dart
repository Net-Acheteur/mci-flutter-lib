part of 'current_localization_delegate_abstract.dart';

class BaseCurrentLocalizationDelegate extends CurrentLocalizationDelegateAbstract {
  BaseCurrentLocalizationDelegate({Locale? locale}) {
    currentLocale = locale ?? Locale(Intl.systemLocale.substring(0, 2));
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
