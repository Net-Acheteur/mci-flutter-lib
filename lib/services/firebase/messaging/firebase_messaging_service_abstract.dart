import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mci_flutter_lib/models/notification.dart';
import 'package:mci_flutter_lib/services/current_localization_delegate_abstract.dart';
import 'package:rxdart/rxdart.dart';

part 'firebase_messaging_service.dart';

abstract class FirebaseMessagingServiceAbstract {
  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late final BaseCurrentLocalizationDelegate localizationDelegate;

  /// Used for notifications opened (start, background, foreground)
  late final BehaviorSubject<NotificationModel> _streamNotificationsOpened;
  Stream<NotificationModel> get notificationsOpened;

  /// Used for notifications received (open or not) on foreground
  late final BehaviorSubject<NotificationModel> _streamNotificationsReceived;
  Stream<NotificationModel> get notificationsReceived;

  FirebaseMessagingServiceAbstract({required this.localizationDelegate});

  /// Init the service with firebase configurations
  Future<void> init();

  /// Init local notifications for Android and iOS
  Future<void> initLocalNotifications();

  /// Ask for device permissions to receive notifications
  Future<NotificationSettings> askForPermissions();

  /// Recover FCM token
  Future<String?> getFCMToken();

  /// Called when a local notification is opened
  Future<void> onOpenedLocalNotification(String? payload);

  /// Called when the app is running and a notification is opened on the background
  void onOpenedNotificationBackground();

  /// Called when the app is not running and a notification is opened on the background
  void onOpenedAppFromNotification();

  /// Called when the app is running and a notification is received on the foreground
  void onMessageReceivedForeground();

  /// Return a translated string from a notification
  /// To be override by the project to return the correct translation
  String translateMessage(String key, List<String> args);

  /// Add a notification on the StreamController
  /// To be override by the project to register the correct notification
  void registerNotification(Map<String, dynamic> data, BehaviorSubject<NotificationModel> stream);

  /// Return a notification model from the data of a raw notification
  /// To be override by the project to return the correct notification
  NotificationModel? convertToNotification(Map<String, dynamic> payload);
}
