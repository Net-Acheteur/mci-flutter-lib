part of 'firebase_messaging_service_abstract.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class BaseFirebaseMessagingService extends FirebaseMessagingServiceAbstract {
  BaseFirebaseMessagingService(BaseCurrentLocalizationDelegate l) : super(localizationDelegate: l) {
    _streamNotificationsOpened = BehaviorSubject<NotificationModel>();
    _streamNotificationsReceived = BehaviorSubject<NotificationModel>();
  }

  @override
  Stream<NotificationModel> get notificationsOpened async* {
    yield* _streamNotificationsOpened.stream;
  }

  @override
  Stream<NotificationModel> get notificationsReceived async* {
    yield* _streamNotificationsReceived.stream;
  }

  @override
  init() async {
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'default_notification_channel_id',
        'Default Importance Notifications',
        description: 'This channel is used for notifications.',
        importance: Importance.defaultImportance,
      );

      await initLocalNotifications();

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    }

    onOpenedAppFromNotification();
    onOpenedNotificationBackground();
    onMessageReceivedForeground();

    askForPermissions();
  }

  @override
  initLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/ic_stat_netac_icon");
    const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onOpenedLocalNotification,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  askForPermissions() async {
    return await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  @override
  getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  onOpenedLocalNotification(String? payload) async {
    if (payload != null) {
      Map<String, dynamic> resultPayload = json.decode(payload) as Map<String, dynamic>;
      registerNotification(resultPayload, _streamNotificationsOpened);
    }
  }

  @override
  onOpenedNotificationBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      registerNotification(message.data, _streamNotificationsOpened);
    });
  }

  @override
  onOpenedAppFromNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        registerNotification(message.data, _streamNotificationsOpened);
      }
    });
  }

  @override
  onMessageReceivedForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      if (message != null) {
        RemoteNotification? notification = message.notification;
        registerNotification(message.data, _streamNotificationsReceived);
        if (notification != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              translateMessage(notification.titleLocKey, notification.titleLocArgs),
              translateMessage(notification.bodyLocKey, notification.bodyLocArgs),
              NotificationDetails(
                  android: AndroidNotificationDetails(channel.id, channel.name,
                      channelDescription: channel.description, color: const Color.fromRGBO(0, 56, 94, 1)),
                  iOS: const IOSNotificationDetails()),
              payload: json.encode(message.data));
        }
      }
    });
  }

  @override
  translateMessage(String? key, List<String>? args) {
    return key ?? "";
  }

  @override
  registerNotification(Map<String, dynamic> data, BehaviorSubject<NotificationModel> stream) {
    NotificationModel? notification = convertToNotification(data);
    if (notification != null) {
      stream.add(notification);
    }
  }

  @override
  convertToNotification(Map<String, dynamic> payload) {
    return NotificationEmpty();
  }
}
