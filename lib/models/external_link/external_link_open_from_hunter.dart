import 'package:mci_flutter_lib/models/external_link/external_link.dart';

class ExternalLinkOpenFromHunter extends ExternalLinkModel {
  static String tokenParameterName = 'token';

  final String token;

  const ExternalLinkOpenFromHunter({required this.token}) : super();

  factory ExternalLinkOpenFromHunter.fromUrl(String url) {
    final Uri uri = Uri.parse(url);
    return ExternalLinkOpenFromHunter(token: uri.queryParameters[tokenParameterName] ?? '');
  }
}
