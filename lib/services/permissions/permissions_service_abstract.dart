import 'package:permission_handler/permission_handler.dart';

abstract class PermissionsServiceAbstract {
  Future<bool> permissionAuthorized(Permission permission);
  Future<bool> storageAuthorized();
  Future<bool> photosAuthorized();
  Future<bool> cameraAuthorized();
  Future<bool> notificationsAuthorized();
}
