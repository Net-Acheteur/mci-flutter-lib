import 'package:flutter/foundation.dart';
import 'package:mci_flutter_lib/services/platform/platform_service_abstract.dart';

class PlatformService implements PlatformServiceAbstract {
  @override
  isAndroid() => false;

  @override
  isIOS() => false;

  @override
  isWeb() => kIsWeb;
}
