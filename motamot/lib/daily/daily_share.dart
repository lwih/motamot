import 'package:flutter/services.dart';
import 'package:motamot/daily/daily_model.dart';
import 'package:motamot/ui/design.dart';
import 'package:motamot/utils.dart';

import '../utils/date_utils.dart';

String displayRow(String wordToFind, String word) {
  final statuses = getColorMapCorrection(wordToFind, word);
  final list = List.generate(wordToFind.length, (i) {
    if (statuses[i] == WordValidationStatus.goodPosition) {
      return "🟩";
    } else if (statuses[i] == WordValidationStatus.wrongPosition) {
      return "🟧";
    } else if (statuses[i] == WordValidationStatus.notInWord ||
        statuses[i] == WordValidationStatus.ignored) {
      return "⬛";
    } else {
      return "⬛";
    }
  });
  return list.join('');
}

String displayRows(String wordToFind, List<String> words) {
  StringBuffer sb = StringBuffer();
  for (var word in words) {
    sb.write('${displayRow(wordToFind, word)}\n');
  }
  return sb.toString();
}

Future<void> shareDailyResults(Daily daily) async {
  ClipboardData text = ClipboardData(text: """
Le mot du jour ${formattedTodayInFrench()}
Score: ${daily.words!.length}/6

${displayRows(daily.word, daily.words!)}
  
https://play.google.com/store/apps/details?id=com.lwih.motamot&gl=FR
  """);
  await Clipboard.setData(text);
}
