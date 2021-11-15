import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

part 'firebase_crashlytics_service.dart';

abstract class FirebaseCrashlyticsServiceAbstract {
  Future<void> init();

  Future<void> sendError(String error, StackTrace stack, String reason);

  void setUserId(userId);
}
