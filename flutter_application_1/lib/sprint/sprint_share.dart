import 'package:flutter/services.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';

Future<void> shareSprintResults(Sprint sprint) async {
  ClipboardData text = const ClipboardData(text: """
  MOUTIUS #92 1/6
  🟥🟥🟥🟥🟥🟥🟥
  link play store
  """);
  await Clipboard.setData(text);
}
