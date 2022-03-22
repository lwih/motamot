import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/gameplay/row.dart';

@immutable
class WordGrid extends StatelessWidget {
  final int numberOfRows;
  final String firstLetter;
  final List<String> words;
  final String wordInProgress;
  final String wordToFind;
  final int activeRow;

  List<String> createUntouchedRows() {
    final int amountOfRowsLeft = numberOfRows - words.length - 1;
    final int wordLength = wordToFind.length;
    String fakeEmptyWorld = '';
    for (var i = 0; i < wordLength; i++) {
      fakeEmptyWorld = '$fakeEmptyWorld-';
    }

    List<String> rows = [];
    for (var i = 0; i < amountOfRowsLeft; i++) {
      rows.add(fakeEmptyWorld);
    }
    return rows;
  }

  String withWhiteSpace(String wordInProgress, int desiredLength) {
    final int currentLength = wordInProgress.length;
    String wordWithSpaces = wordInProgress;
    for (var i = 0; i < desiredLength - currentLength; i++) {
      wordWithSpaces = '$wordWithSpaces ';
    }
    return wordWithSpaces;
  }

  const WordGrid(
      {required this.numberOfRows,
      required this.firstLetter,
      required this.words,
      required this.wordInProgress,
      required this.wordToFind,
      required this.activeRow,
      Key? key})
      : super(key: key);

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
      WordRow(
        word: withWhiteSpace(wordInProgress, wordToFind.length).split(''),
        wordToFind: wordToFind.split(''),
        validateRow: false,
      ),
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
