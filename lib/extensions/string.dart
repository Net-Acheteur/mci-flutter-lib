extension Capitalization on String {
  String get capitalizeFirst => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get capitalizeFirstAllWords =>
      replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.capitalizeFirst).join(" ");
  String get replaceSpaceByLineJump => replaceAll(' ', '\n');
}
