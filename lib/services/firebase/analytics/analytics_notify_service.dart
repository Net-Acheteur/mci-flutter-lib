part of 'analytics_notify_service_abstract.dart';

class BaseAnalyticsNotifyService implements AnalyticsNotifyServiceAbstract {
  late final AppConfigAbstract _appConfig;
  late FirebaseAnalytics _analytics;
  late String environment;
  String _userId = '';

  BaseAnalyticsNotifyService({required AppConfigAbstract appConfig}) {
    _appConfig = appConfig;
    _analytics = FirebaseAnalytics.instance;
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
    _analytics.setUserId(id: userId);
    _userId = userId;
  }

  @override
  logEvent(String eventName, {Map<String, Object>? parameters}) {
    Map<String, Object> parametersToReturn = parameters != null ? Map<String, Object>.from(parameters) : {};
    parametersToReturn['userId'] = _userId;
    _analytics.logEvent(name: eventName, parameters: parametersToReturn);
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
