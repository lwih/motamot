import 'package:intl/intl.dart';

String formattedToday() {
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);
  var formattedDate = DateFormat("yyyy-MM-dd").format(date);
  return formattedDate;
}

String formattedTodayInFrench() {
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);
  var formattedDate = DateFormat("dd/MM/yy").format(date);
  return formattedDate;
}

bool isSunday(DateTime date) {
  String day = DateFormat('EEEE').format(date);
  return day == 'Sunday';
}
