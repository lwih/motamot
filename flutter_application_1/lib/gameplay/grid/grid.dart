import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/gameplay/grid/row.dart';

import 'animated_row.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = ((screenWidth - 50) / wordToFind.length) - 10;
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...words.map((word) {
                return Flexible(
                  flex: 1,
                  child: WordRow(
                    key: Key('Row$word'),
                    word: word.split(''),
                    wordToFind: wordToFind.split(''),
                    validateRow: true,
                    size: cellSize,
                  ),
                );
              }).toList(),
              !finished && hasAnyRowLeft()
                  ? Flexible(
                      flex: 1,
                      child: AnimatedWordRow(
                        controller: animationController,
                        size: cellSize,
                        wordToFind: wordToFind,
                        showHints: showHints,
                        word: showHints
                            ? hints
                            : wordInProgress.padRight(wordToFind.length, ' '),
                      ),
                    )
                  : Flexible(
                      flex: 0,
                      child: Container(),
                    ),
              ...createUntouchedRows().map((String emptyWord) {
                return Flexible(
                  flex: 1,
                  child: WordRow(
                    size: cellSize,
                    word: emptyWord.split(''),
                    wordToFind: wordToFind.split(''),
                    validateRow: false,
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
