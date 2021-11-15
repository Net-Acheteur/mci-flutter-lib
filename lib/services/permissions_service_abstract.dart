import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

part 'permissions_service.dart';

abstract class PermissionsServiceAbstract {
  Future<bool> permissionAuthorized(Permission permission);
  Future<bool> storageAuthorized();
  Future<bool> photosAuthorized();
  Future<bool> cameraAuthorized();
}
