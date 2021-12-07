import 'dart:math';

extension DoubleExtension on double {
  double toDecimal(int decimal) {
    num mod = pow(10.0, decimal);
    return ((this * mod).round().toDouble() / mod);
  }
}
