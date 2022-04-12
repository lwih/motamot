import 'package:flutter/services.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';

Future<void> shareSprintResults(int score) async {
  ClipboardData text = ClipboardData(text: """
Le sprint du Mouitus

Score: ${score.toString()}

link play store
  """);
  await Clipboard.setData(text);
}
