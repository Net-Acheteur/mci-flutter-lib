extension JsonExtension on Map<String, dynamic> {
  String? getNullableString(String name) {
    return this[name]?.toString();
  }

  String getString(String name) {
    String? nullableString = getNullableString(name);
    return nullableString ?? '';
  }

  DateTime? getNullableDateTime(String name) {
    return this[name] != null ? getDateTime(name) : null;
  }

  DateTime getDateTime(String name) {
    return DateTime.parse(this[name]);
  }

  bool getBool(String name) {
    return this[name] is bool ? this[name] : false;
  }

  int? getNullableInt(String name) {
    dynamic tempInt = this[name];
    if (tempInt is int) {
      return tempInt;
    } else if (tempInt is double) {
      return tempInt.toInt();
    } else if (tempInt is String) {
      return int.parse(tempInt);
    }
    return null;
  }

  int getInt(String name) {
    int? nullableInt = getNullableInt(name);
    return nullableInt ?? 0;
  }

  double? getNullableDouble(String name) {
    dynamic tempDouble = this[name];
    if (tempDouble is int) {
      return tempDouble.toDouble();
    } else if (tempDouble is double) {
      return tempDouble;
    } else if (tempDouble is String) {
      return double.parse(tempDouble);
    }
    return null;
  }

  double getDouble(String name) {
    double? nullableDouble = getNullableDouble(name);
    return nullableDouble ?? 0.0;
  }

  List<T> getList<T>(String name, T Function(dynamic) mapper) {
    return this[name] != null ? (this[name] as List<dynamic>).map<T>((p) => mapper(p)).toList() : [];
  }

  Map<T, TT> getMap<T, TT>(String name, T Function(dynamic) mapperKey, TT Function(dynamic) mapperValue) {
    Map<T, TT> result = <T, TT>{};

    if (!(this[name] == null || this[name] == '' || this[name] is! Map<dynamic, dynamic>)) {
      Map<dynamic, dynamic> data = this[name];

      try {
        data.forEach((key, value) {
          result.putIfAbsent(mapperKey(key), () => mapperValue(value));
        });
      } catch (_) {
        return result;
      }
    }
    return result;
  }
}
