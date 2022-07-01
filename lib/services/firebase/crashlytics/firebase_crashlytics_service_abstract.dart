abstract class FirebaseCrashlyticsServiceAbstract {
  Future<void> init();

  Future<void> sendError(String error, StackTrace stack, String reason);

  void setUserId(userId);
}
