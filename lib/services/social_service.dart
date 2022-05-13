part of 'social_service_abstract.dart';

class SocialService implements SocialServiceAbstract {
  @override
  Future<bool> activateSocial(SocialType socialType, String identifier,
      {String message = '', String subject = ''}) async {
    String action = "";

    switch (socialType) {
      case SocialType.sms:
        action = ("sms:$identifier${Platform.isIOS ? '&' : '?'}body=${Uri.encodeFull(message)}");
        break;
      case SocialType.mail:
        action = ("mailto:$identifier?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}");
        break;
      case SocialType.phone:
        action = ("tel:${identifier.replaceAll(' ', '')}");
        break;
      case SocialType.whatsapp:
        if (Platform.isIOS) {
          action = "whatsapp://wa.me/$identifier/?text=${Uri.encodeFull(message)}}";
          if (!await canLaunchUrl(Uri.parse(action))) {
            action = "https://apps.apple.com/fr/app/whatsapp-messenger/id310633997";
          }
        } else {
          action = "whatsapp://send?phone=$identifier&text=${Uri.encodeFull(message)}";
          if (!await canLaunchUrl(Uri.parse((action)))) {
            action = "https://play.google.com/store/apps/details?id=com.whatsapp";
          }
        }
        break;
      case SocialType.skype:
        action = "skype:$identifier";
        if (!await canLaunchUrl(Uri.parse(action))) {
          if (Platform.isIOS) {
            action = "https://apps.apple.com/fr/app/skype-pour-iphone/id304878510";
          } else {
            action = "https://play.google.com/store/apps/details?id=com.skype.raider";
          }
        }
        break;
    }

    if (action != "" && await canLaunchUrl(Uri.parse(action))) {
      await launchUrl(Uri.parse(action));
      return true;
    }

    return false;
  }
}
