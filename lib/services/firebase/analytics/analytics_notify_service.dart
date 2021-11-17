part of 'analytics_notify_service_abstract.dart';

class BaseAnalyticsNotifyService implements AnalyticsNotifyServiceAbstract {
  late final AppConfigAbstract _appConfig;
  late FirebaseAnalytics _analytics;
  late String environment;

  BaseAnalyticsNotifyService({required AppConfigAbstract appConfig}) {
    _appConfig = appConfig;
    _analytics = FirebaseAnalytics();
    _analytics.setUserProperty(name: 'environment', value: _appConfig.getEnvironment());
  }

  @override
  NavigatorObserver createObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  @override
  login() {
    _analytics.logLogin();
  }

  @override
  setUserId(String userId) {
    _analytics.setUserId(userId);
  }

  @override
  logEvent(String eventName, {Map<String, Object>? parameters}) {
    _analytics.logEvent(name: eventName, parameters: parameters);
  }

  /// Custom events
  @override
  createParameters(List<Tuple2<String, Object>> parameters) {
    Map<String, Object> parametersToReturn = {};
    for (var tuple in parameters) {
      parametersToReturn.putIfAbsent(tuple.item1, () => tuple.item2);
    }
    return parametersToReturn;
  }
}
