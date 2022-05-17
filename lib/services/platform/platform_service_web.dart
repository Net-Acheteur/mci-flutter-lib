import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:mci_flutter_lib/services/platform/platform_service_abstract.dart';

class PlatformService implements PlatformServiceAbstract {
  @override
  isAndroid() => false;

  @override
  isIOS() => false;

  @override
  isWeb() => kIsWeb;

  @override
  isWebGl2Available() {
    try {
      CanvasElement canvas = CanvasElement();
      Object? ctx = canvas.getContext('webgl2');
      canvas.remove();
      return ctx != null;
    } catch (e) {
      return false;
    }
  }
}
