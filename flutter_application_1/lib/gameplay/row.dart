import 'package:flutter/material.dart';

@immutable
class WordRow extends StatelessWidget {
  final List<String> word;
  final List<String> wordToFind;
  final bool validateRow;

  static var i = -1;

  String decide(List<String> word, String givenLetter, int i) {
    final letterToFind = word[i];
    if (letterToFind == givenLetter) {
      return 'good_position';
    } else if (word.contains(givenLetter)) {
      return 'wrong_position';
    } else {
      return 'not_in_word';
    }
  }

  Color associateColor(String result, int i) {
    if (result == 'good_position') {
      return goodPositionColor;
    } else if (result == 'wrong_position') {
      return wrongPositionColor;
    } else {
      return defaultColor;
    }
  }

  static const Color defaultColor = Colors.blue;
  static const Color goodPositionColor = Colors.green;
  static const Color wrongPositionColor = Colors.orange;

  Color getColor(
      List<String> wordToFind, List<String> word, String letter, int pos) {
    return (pos == 0 && word[0] == wordToFind[0])
        ? goodPositionColor
        : validateRow
            ? associateColor(decide(wordToFind, letter, pos), pos)
            : defaultColor;
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
        return Container(
          color: getColor(wordToFind, word, letter, i),
          width: (screenWidth / wordToFind.length) - 10,
          height: screenWidth / wordToFind.length - 10,
          child: Text(letter),
        );
      }).toList(),
    );
  }
}
