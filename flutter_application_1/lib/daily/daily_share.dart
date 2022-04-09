import 'package:flutter/services.dart';
import 'package:flutter_application_1/daily/daily_model.dart';

Future<void> shareDailyResults(Daily daily) async {
  ClipboardData text = const ClipboardData(text: """
  MOUTIUS #92 1/6
  🟥🟥🟥🟥🟥🟥🟥
  link play store
  """);
  await Clipboard.setData(text);
}
