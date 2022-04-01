import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/grid/animated_row.dart';
import 'package:flutter_application_1/grid/row.dart';

@immutable
class WordGrid extends StatelessWidget {
  final int numberOfRows;
  final String firstLetter;
  final List<String> words;
  final String wordInProgress;
  final String wordToFind;
  final String hints;
  final bool showHints;
  final bool finished;
  final AnimationController animationController;

  bool hasAnyRowLeft() {
    return numberOfRows - words.length > 0;
  }

  List<String> createUntouchedRows() {
    final List<String> rows = [];
    final int amountOfRowsLeft =
        numberOfRows - words.length - 1 + (finished ? 1 : 0);
    String fakeEmptyWorld = ''.padRight(wordToFind.length, ' ');
    for (var i = 0; i < amountOfRowsLeft; i++) {
      rows.add(fakeEmptyWorld);
    }
    return rows;
  }

  const WordGrid({
    required this.numberOfRows,
    required this.firstLetter,
    required this.words,
    required this.wordInProgress,
    required this.wordToFind,
    required this.hints,
    required this.showHints,
    required this.animationController,
    required this.finished,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...words.map((word) {
        return WordRow(
          word: word.split(''),
          wordToFind: wordToFind.split(''),
          validateRow: true,
        );
      }).toList(),
      !finished && hasAnyRowLeft()
          ? AnimatedWordRow(
              controller: animationController,
              wordToFind: wordToFind,
              showHints: showHints,
              word: showHints
                  ? hints
                  : wordInProgress.padRight(wordToFind.length, ' '),
            )
          : Column(),
      ...createUntouchedRows().map((String emptyWord) {
        return WordRow(
          word: emptyWord.split(''),
          wordToFind: wordToFind.split(''),
          validateRow: false,
        );
      }).toList(),
    ]);
  }
}
