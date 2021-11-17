import 'package:connectivity/connectivity.dart';

part 'connectivity_service.dart';

abstract class ConnectivityServiceAbstract {
  Future<bool> isConnected();
}
