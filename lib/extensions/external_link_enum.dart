import 'package:mci_flutter_lib/infrastructure/external_link_enum.dart';

extension ExternalLinkEnumExtensions on ExternalLinkEnum {
  String get uriParameterName {
    switch (this) {
      case ExternalLinkEnum.openFromHunter:
        return 'openFromHunter';
    }
  }
}
