abstract class AppConfigAbstract {
  /// Is the config is on production
  bool isProduction();

  /// Is the config is on staging
  bool isStaging();

  /// Which env (PROD, STG or DEV) the config is on
  String getEnvironment();
}
