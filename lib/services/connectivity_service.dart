part of 'connectivity_service_abstract.dart';

class ConnectivityService implements ConnectivityServiceAbstract {
  @override
  Future<bool> isConnected() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
