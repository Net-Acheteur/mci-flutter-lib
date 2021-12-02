part of 'permissions_service_abstract.dart';

class PermissionsService implements PermissionsServiceAbstract {
  @override
  permissionAuthorized(Permission permission) async {
    PermissionStatus permissionStatus = await permission.status;
    if (!permissionStatus.isGranted && !permissionStatus.isPermanentlyDenied) {
      await permission.request();
      permissionStatus = await permission.status;
    }
    return permissionStatus.isGranted;
  }

  @override
  storageAuthorized() async {
    return permissionAuthorized(Permission.storage);
  }

  @override
  photosAuthorized() async {
    return permissionAuthorized(Permission.photos);
  }

  @override
  cameraAuthorized() async {
    return permissionAuthorized(Permission.camera);
  }

  @override
  notificationsAuthorized() async {
    return permissionAuthorized(Permission.notification);
  }
}
