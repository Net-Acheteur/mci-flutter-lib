import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mci_flutter_lib/config/app_config.dart';
import 'package:tuple/tuple.dart';

part 'analytics_notify_service.dart';

abstract class AnalyticsNotifyServiceAbstract {
  NavigatorObserver createObserver();
  void login();
  void setUserId(String userId);
  void logEvent(String eventName, {Map<String, Object>? parameters});
  Map<String, Object> createParameters(List<Tuple2<String, Object>> parameters);
}
