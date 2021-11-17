import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat.yMd(Intl.getCurrentLocale()).format(this);

  DateTime get castAsUtc => isUtc ? this : DateTime.parse('${toString()}Z');

  String get readableDate {
    DateTime utcDateTime = toLocal();
    String d = DateFormat('EEEE').format(utcDateTime);
    String j = utcDateTime.day.toString();
    String m = DateFormat('LLLL').format(utcDateTime);
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
