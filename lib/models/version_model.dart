class VersionModel {
  final int major;
  final int minor;
  final int revision;

  const VersionModel({
    required this.major,
    required this.minor,
    required this.revision,
  });

  factory VersionModel.empty() {
    return const VersionModel(
      major: 0,
      minor: 0,
      revision: 0,
    );
  }

  factory VersionModel.fromString(String version) {
    List<String> separated = version.split('.');
    if (separated.length != 3) {
      return VersionModel.empty();
    }
    try {
      int major = int.parse(separated[0]);
      int minor = int.parse(separated[1]);
      int revision = int.parse(separated[2]);
      return VersionModel(
        major: major,
        minor: minor,
        revision: revision,
      );
    } catch (_) {
      return VersionModel.empty();
    }
  }

  bool get isValid => !(major == 0 && minor == 0 && revision == 0);

  String get display => "v $major.$minor.$revision";

  String get stringToSave => "$major.$minor.$revision";
}
