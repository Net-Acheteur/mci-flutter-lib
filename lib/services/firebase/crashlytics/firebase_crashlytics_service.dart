part of 'firebase_crashlytics_service_abstract.dart';

class FirebaseCrashlyticsService implements FirebaseCrashlyticsServiceAbstract {
  FirebaseCrashlyticsService() {
    init();
  }

  @override
  Future<void> init() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  @override
  Future<void> sendError(error, stack, reason) async {
    await FirebaseCrashlytics.instance.recordError(error, stack, reason: reason, fatal: false);
  }

  @override
  void setUserId(userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
}
