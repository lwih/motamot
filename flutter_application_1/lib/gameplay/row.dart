import 'package:flutter/material.dart';

@immutable
class WordRow extends StatelessWidget {
  final List<String> word;
  final List<String> wordToFind;
  final bool validateRow;

  static var i = -1;

  String decide(List<String> words, String givenLetter, int i) {
    final letterToFind = words[i];
    if (letterToFind == givenLetter) {
      return 'good_position';
    } else if (words.contains(givenLetter)) {
      return 'wrong_position';
    } else {
      return 'not_in_word';
    }
  }

  Color getColor(String result) {
    if (result == 'good_position') {
      return Colors.red;
    } else if (result == 'wrong_position') {
      return Colors.orange;
    } else {
      return defaultColor();
    }
  }

  Color defaultColor() {
    return Colors.blue;
  }

  const WordRow(
      {required this.word,
      required this.wordToFind,
      required this.validateRow,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    i = 0;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: word.map((String letter) {
        final color = validateRow
            ? getColor(decide(wordToFind, letter, i))
            : defaultColor();
        i++;
        return Column(
          children: [
            AnimatedContainer(
                duration: const Duration(seconds: 1),
                color: color,
                width: (screenWidth / wordToFind.length) - 10,
                height: screenWidth / wordToFind.length - 10,
                child: Text(letter)),
          ],
        );
      }).toList(),
    );
  }
}
