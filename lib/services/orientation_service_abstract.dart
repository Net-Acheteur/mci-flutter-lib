import 'package:flutter/services.dart';

part 'orientation_service.dart';

abstract class OrientationServiceAbstract {
  void portraitUpModeOnly();
  void enableRotation();
}
