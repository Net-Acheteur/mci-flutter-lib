import 'package:connectivity_plus/connectivity_plus.dart';

part 'connectivity_service.dart';

abstract class ConnectivityServiceAbstract {
  Future<bool> isConnected();
}
