import 'package:intl/intl.dart';
import 'package:mci_flutter_lib/extensions/string.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat.yMd(Intl.getCurrentLocale()).format(this);

  DateTime get castAsUtc => isUtc ? this : DateTime.parse('${toString()}Z');

  String get readableDate {
    return readableDateWithLocale(Intl.getCurrentLocale());
  }

  String readableDateWithLocale(String locale) {
    DateTime utcDateTime = toLocal();
    String d = DateFormat('EEEE', locale).format(utcDateTime).capitalizeFirst;
    String j = utcDateTime.day.toString();
    String m = DateFormat('LLLL', locale).format(utcDateTime);
    String h = utcDateTime.hour.toString();
    if (h.length == 1) {
      h = '0$h';
    }
    String mm = utcDateTime.minute.toString();
    if (mm.length == 1) {
      mm = '0$mm';
    }
    return '$d $j $m • $h:$mm';
  }
}
