import 'package:mci_flutter_lib/models/external_link/external_link.dart';

class ExternalLinkOpenFromHunter extends ExternalLinkModel {
  static String tokenParameterKey = 'token';
  static String userIdKey = 'userId';
  static String userFullNameKey = 'userFullName';
  static String mandateIdKey = 'mandateId';

  final String token;
  final String userId;
  final String userFullName;
  final String mandateId;

  const ExternalLinkOpenFromHunter({
    required this.token,
    required this.userId,
    required this.userFullName,
    required this.mandateId,
  }) : super();

  factory ExternalLinkOpenFromHunter.fromUrl(String url) {
    final Uri uri = Uri.parse(url);
    return ExternalLinkOpenFromHunter(
      token: uri.queryParameters[tokenParameterKey] ?? '',
      userId: uri.queryParameters[userIdKey] ?? '',
      userFullName: uri.queryParameters[userFullNameKey] ?? '',
      mandateId: uri.queryParameters[mandateIdKey] ?? '',
    );
  }
}
