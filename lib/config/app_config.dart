class AppConfig {
  late final String _aadOauthTenant;

  AppConfig(this._aadOauthTenant);
  bool isProduction() => _aadOauthTenant.endsWith("prod");
  bool isStaging() => _aadOauthTenant.endsWith("stg");
  String getEnvironment() {
    if (isProduction()) {
      return "production";
    } else if (isStaging()) {
      return "staging";
    } else {
      return "development";
    }
  }
}
