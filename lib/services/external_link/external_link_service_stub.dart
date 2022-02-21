import 'package:mci_flutter_lib/services/external_link/external_link_service_abstract.dart';

class ExternalLinkService implements ExternalLinkServiceAbstract {
  @override
  Future<bool> checkIfAppAvailable(String packageName) async {
    return false;
  }

  @override
  Future<bool> launchAppWithParams(String packageName, {String? prefix, Map<String, String>? arguments}) async {
    return false;
  }

  @override
  Future<bool> launchStorePage(String packageStoreUrl) async {
    return false;
  }
}
