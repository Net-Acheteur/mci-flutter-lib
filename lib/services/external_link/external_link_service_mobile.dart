import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'external_link_service_abstract.dart';

class ExternalLinkService implements ExternalLinkServiceAbstract {
  _addAndroidPrefix(String packageName) => 'mci://$packageName';

  @override
  Future<bool> checkIfAppAvailable(String packageName) async {
    if (kIsWeb) {
      return false;
    }

    if (Platform.isAndroid) {
      return await canLaunch(_addAndroidPrefix(packageName));
    } else if (Platform.isIOS) {
      // TODO
    }
    return false;
  }

  @override
  Future<bool> launchAppWithParams(String packageName, {String? prefix, Map<String, String>? arguments}) async {
    String paramQuery = '';
    if (arguments != null && arguments.isNotEmpty) {
      arguments.forEach((key, value) {
        if (paramQuery.isNotEmpty) {
          paramQuery += '&';
        }
        paramQuery += '$key=$value';
      });
    }

    String request = _addAndroidPrefix(packageName);
    if (prefix != null && prefix.isNotEmpty) {
      request += '/$prefix';
    }
    if (paramQuery.isNotEmpty) {
      request += '?$paramQuery';
    }

    return await launch(request);
  }

  @override
  Future<bool> launchStorePage(String packageStoreUrl) async {
    return await launch(packageStoreUrl);
  }
}
