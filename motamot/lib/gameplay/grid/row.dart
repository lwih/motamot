import 'package:flutter/material.dart';
import 'package:motamot/gameplay/grid/cell.dart';
import 'package:motamot/ui/design.dart';
import 'package:motamot/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@immutable
class WordRow extends StatelessWidget {
  final double size;
  final List<String> word;
  final List<String> wordToFind;
  final bool validateRow;

  static var i = -1;

  Color getColor(
      List<String> wordToFind, List<String> word, String letter, int pos) {
    final statuses = getColorMapCorrection(wordToFind.join(''), word.join(''));
    final list = List.generate(wordToFind.length, (i) {
      if (statuses[i] == WordValidationStatus.goodPosition) {
        return CustomColors.rightPosition;
      } else if (statuses[i] == WordValidationStatus.wrongPosition) {
        return CustomColors.wrongPosition;
      } else if (statuses[i] == WordValidationStatus.notInWord ||
          statuses[i] == WordValidationStatus.ignored) {
        return CustomColors.disabledBackgroundColor;
      } else {
        return CustomColors.lighterBackgroundColor;
      }
    });
    return (pos == 0 && word[0] == wordToFind[0])
        ? CustomColors.rightPosition
        : validateRow
            ? list[pos]
            : CustomColors.lighterBackgroundColor;
  }

  const WordRow(
      {required this.size,
      required this.word,
      required this.wordToFind,
      required this.validateRow,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i = -1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: word.map((String letter) {
        i++;
        return Padding(
          padding: const EdgeInsets.all(1),
          child: Cell(
            color: getColor(wordToFind, word, letter, i),
            text: letter.toUpperCase(),
            size: size,
            fontSize: wordToFind.length > 8 ? 16.sp : 18.sp,
          ),
        );
      }).toList(),
    );
  }
}
