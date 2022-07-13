/// Support for doing something awesome.
///
/// More dartdocs go here.
library mci_flutter_lib;

/// Config
export 'config/app_config.dart' show AppConfigAbstract;
export 'config/mci_colors.dart' show MCIColors;

/// Core
export 'core/processing_result.dart' show BaseProcessingResult, ProcessingState;

/// Extensions
export 'extensions/date_time.dart' show DateTimeExtensions;
export 'extensions/external_link_enum.dart' show ExternalLinkEnumExtensions;
export 'extensions/iterable.dart' show IterableExtension, SetExtension;
export 'extensions/json.dart' show JsonExtension;
export 'extensions/latlng.dart' show LatLngExtensions, LatLngListExtensions, LatLngListListExtensions;
export 'extensions/polygon_model.dart' show PolygonModelExtension, PolygonModelListExtension;
export 'extensions/stream.dart' show StreamExtensions;
export 'extensions/string.dart' show Capitalization;

/// Generators
export 'generators/marker_generator.dart' show MarkerGenerator;

/// Helpers
export 'helpers/cluster_manager_helper.dart' show ClusterManagerHelper;
export 'helpers/crypto_helper.dart' show CryptoHelper;
export 'helpers/google_map_helper.dart' show GoogleMapHelper;
export 'helpers/image_helper.dart' show ImageHelper;
export 'helpers/version_helper.dart' show VersionHelper, VersionComparison;
export 'helpers/wkt_helper.dart' show WKTHelper;
export 'image_preloader.dart' show loadImage;

/// Infrastructure
export 'infrastructure/closable_multipart_request.dart' show CloseableMultipartRequest;
export 'infrastructure/dtos/notification_dto.dart'
    show BaseNotificationDto, NotificationPayloadDto, NotificationPayloadEmptyDto;
export 'infrastructure/external_link_enum.dart' show ExternalLinkEnum;

/// Mixins
export 'mixins/cubit.dart' show CubitPreventsEmitOnClosed;

/// Models
export 'models/external_link/external_link.dart' show ExternalLinkModel;
export 'models/external_link/external_link_open_from_hunter.dart' show ExternalLinkOpenFromHunter;
export 'models/map/map_circle_object.dart' show MapCircleObjectModel;
export 'models/map/map_cluster_object.dart' show MapClusterElementObjectModel, MapClusterGroupObjectModel;
export 'models/map/map_object.dart' show MapObjectModel, MapObjectModelWithBounds;
export 'models/map/map_polygon_object.dart' show MapPolygonObjectModel;
export 'models/map/place_style.dart' show PlaceStyle;
export 'models/map/polygon_model.dart' show PolygonModel;
export 'models/notification.dart' show NotificationModel, NotificationEmpty;
export 'models/version_model.dart' show VersionModel;

/// Services
export 'services/connectivity_service_abstract.dart' show ConnectivityServiceAbstract, ConnectivityService;
export 'services/current_localization_delegate_abstract.dart'
    show CurrentLocalizationDelegateAbstract, BaseCurrentLocalizationDelegate;
export 'services/external_link/external_link_service.dart' show ExternalLinkService;
export 'services/firebase/analytics/analytics_notify_service_abstract.dart'
    show AnalyticsNotifyServiceAbstract, BaseAnalyticsNotifyService;
export 'services/firebase/crashlytics/firebase_crashlytics_service.dart' show FirebaseCrashlyticsService;
export 'services/firebase/crashlytics/firebase_crashlytics_service_abstract.dart'
    show FirebaseCrashlyticsServiceAbstract;
export 'services/firebase/messaging/firebase_messaging_service_abstract.dart'
    show FirebaseMessagingServiceAbstract, BaseFirebaseMessagingService;
export 'services/orientation_service_abstract.dart' show OrientationServiceAbstract, OrientationService;
export 'services/permissions/permissions_service.dart' show PermissionsService;
export 'services/permissions/permissions_service_abstract.dart' show PermissionsServiceAbstract;
export 'services/platform/platform_service.dart' show PlatformService;
export 'services/social_service_abstract.dart' show SocialServiceAbstract, SocialService, SocialType;
export 'services/toast_service_abstract.dart' show ToastServiceAbstract, ToastService;
export 'widgets/bounce_button.dart' show BounceButtonMCI;
export 'widgets/drawer.dart' show DrawerMCI;

/// Widgets
export 'widgets/google_map/basic_google_map.dart' show BasicGoogleMap;
export 'widgets/google_map/google_map.dart' show GoogleMapWidget, GoogleMapWidgetState;
export 'widgets/icon_spinner.dart' show IconSpinner;
export 'widgets/image/image.dart' show BaseImageMCI;
export 'widgets/image/image_container.dart' show BaseImageContainerMCI;
export 'widgets/image/image_empty.dart' show ImageEmpty;
export 'widgets/modal.dart' show ModalMCI;
export 'widgets/shimmer_container.dart' show ShimmerContainer;
export 'widgets/smart_refresher.dart' show SmartRefresherMCI, SmartRefresherMCIHeader, SmartRefresherMCIFooter;
