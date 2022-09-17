import 'package:flutter/services.dart';

Future<void> shareSprintResults(int score) async {
  ClipboardData text = ClipboardData(text: """
Le sprint du Motamot

Score: ${score.toString()}

https://play.google.com/store/apps/details?id=com.lwih.motamot&gl=FR
""");
  await Clipboard.setData(text);
}
