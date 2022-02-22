abstract class ExternalLinkServiceAbstract {
  Future<bool> checkIfAppAvailable(String packageName);
  Future<bool> launchAppWithParams(String packageName, {String? prefix, Map<String, String>? arguments});
  Future<bool> launchStorePage(String packageStoreUrl);
}
