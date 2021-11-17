import 'dart:ui';

import 'package:mci_flutter_lib/config/mci_colors.dart';
import 'package:test/test.dart';

void main() {
  group('Test', () {
    final Color color = MCIColors.primary;

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(color.value, Color(0xff00385e).value);
    });
  });
}
