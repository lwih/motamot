import 'package:intl/intl.dart';

String formattedToday() {
  DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);
  var formattedDate = DateFormat("yyyy-MM-dd").format(date);
  return formattedDate;
}
