import 'package:collection/collection.dart';

extension IterableExtension on Iterable {
  int toHashCode() {
    return const IterableEquality().hash(this);
  }
}

extension SetExtension on Set {
  int toHashCode() {
    return const SetEquality().hash(this);
  }
}
