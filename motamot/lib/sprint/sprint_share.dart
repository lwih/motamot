import 'package:flutter/services.dart';
import 'package:motamot/sprint/sprint_model.dart';

Future<void> shareSprintResults(int score) async {
  ClipboardData text = ClipboardData(text: """
Le sprint du Mouitus

Score: ${score.toString()}

link play store
  """);
  await Clipboard.setData(text);
}
