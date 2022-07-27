import 'package:flutter/services.dart';

Future<void> shareSprintResults(int score) async {
  ClipboardData text = ClipboardData(text: """
Le sprint du Motamot

Score: ${score.toString()}

link play store
""");
  await Clipboard.setData(text);
}
