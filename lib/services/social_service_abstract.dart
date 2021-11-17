import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

part 'social_service.dart';

enum SocialType { sms, mail, phone, whatsapp, skype }

abstract class SocialServiceAbstract {
  Future<bool> activateSocial(SocialType socialType, String identifier, {String message, String subject});
}
