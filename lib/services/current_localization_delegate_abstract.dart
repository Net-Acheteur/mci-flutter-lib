import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl_standalone.dart';

part 'current_localization_delegate.dart';

abstract class CurrentLocalizationDelegateAbstract {
  /// Current locale used by the application
  late Locale locale;
  set currentLocale(Locale l);

  /// Current AppLocalizationDelegate used by the application
  late AppLocalizations appLocalizations;
  get currentLocalizationDelegate;
}
