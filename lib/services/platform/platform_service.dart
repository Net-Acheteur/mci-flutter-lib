export 'package:mci_flutter_lib/services/platform/platform_service_stub.dart'
    if (dart.library.io) 'package:mci_flutter_lib/services/external_link/external_link_service_mobile.dart'
    if (dart.library.html) 'package:mci_flutter_lib/services/external_link/external_link_service_web.dart'
    show PlatformService;
