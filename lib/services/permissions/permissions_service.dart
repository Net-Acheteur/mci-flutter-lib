export 'package:mci_flutter_lib/services/permissions/permissions_service_stub.dart'
    if (dart.library.io) 'package:mci_flutter_lib/services/permissions/permissions_service_mobile.dart'
    if (dart.library.html) 'package:mci_flutter_lib/services/permissions/permissions_service_web.dart'
    show PermissionsService;
