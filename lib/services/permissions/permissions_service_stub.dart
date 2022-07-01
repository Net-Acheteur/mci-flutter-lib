import 'package:mci_flutter_lib/services/permissions/permissions_service_abstract.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService implements PermissionsServiceAbstract {
  @override
  permissionAuthorized(Permission permission) async {
    return false;
  }

  @override
  storageAuthorized() async {
    return false;
  }

  @override
  photosAuthorized() async {
    return false;
  }

  @override
  cameraAuthorized() async {
    return false;
  }

  @override
  notificationsAuthorized() async {
    return false;
  }
}
