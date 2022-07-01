import 'package:mci_flutter_lib/services/firebase/crashlytics/firebase_crashlytics_service_abstract.dart';

class FirebaseCrashlyticsService implements FirebaseCrashlyticsServiceAbstract {
  FirebaseCrashlyticsService() {
    init();
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> sendError(error, stack, reason) async {}

  @override
  void setUserId(userId) {}
}
