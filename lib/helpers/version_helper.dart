import 'package:mci_flutter_lib/models/version_model.dart';

enum VersionComparison {
  upToDate,
  late,
  advance,
  unknown,
}

class VersionHelper {
  static VersionComparison versionAVersusVersionB(VersionModel A, VersionModel B) {
    if (A.isValid && B.isValid) {
      if (A.major == B.major) {
        if (A.minor == B.minor) {
          if (A.revision == B.revision) {
            return VersionComparison.upToDate;
          } else if (A.revision > B.revision) {
            return VersionComparison.advance;
          } else {
            return VersionComparison.late;
          }
        } else if (A.minor > B.minor) {
          return VersionComparison.advance;
        } else {
          return VersionComparison.late;
        }
      } else if (A.major > B.major) {
        return VersionComparison.advance;
      } else {
        return VersionComparison.late;
      }
    }
    return VersionComparison.unknown;
  }
}
