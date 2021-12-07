import 'dart:math';

import 'package:mci_flutter_lib/extensions/number.dart';

class OctetHelper {
  static double bytesToMegaBytes(int bytes, {int decimals = 2}) {
    return (bytes / pow(1024, 2)).toDecimal(decimals);
  }
}
