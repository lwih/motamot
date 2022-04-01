import 'package:flutter/material.dart';
import 'package:flutter_application_1/design/design.dart';
import 'package:flutter_application_1/utils.dart';

@immutable
class WordRow extends StatelessWidget {
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
        return CustomColors.backgroundColor;
      } else {
        return CustomColors.notInWord;
      }
    });
    return (pos == 0 && word[0] == wordToFind[0])
        ? CustomColors.rightPosition
        : validateRow
            ? list[pos]
            : CustomColors.notInWord;
  }

  const WordRow(
      {required this.word,
      required this.wordToFind,
      required this.validateRow,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i = -1;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: word.map((String letter) {
        i++;
        return Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            color: getColor(wordToFind, word, letter, i),
            width: (screenWidth / wordToFind.length) - 10,
            height: screenWidth / wordToFind.length - 10,
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: const TextStyle(
                    color: CustomColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
