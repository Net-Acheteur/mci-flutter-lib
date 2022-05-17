import 'dart:io';

import 'package:mci_flutter_lib/services/platform/platform_service_abstract.dart';

class PlatformService implements PlatformServiceAbstract {
  @override
  isAndroid() => Platform.isAndroid;

  @override
  isIOS() => Platform.isIOS;

  @override
  isWeb() => false;
}
