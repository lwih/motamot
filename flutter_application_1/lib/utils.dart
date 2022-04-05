enum WordValidationStatus { goodPosition, wrongPosition, ignored, notInWord }

bool wordIsAcceptable(String word) {
  return true;
}

bool wordHasCorrectLength(String wordToFind, String proposal) {
  return wordToFind.length == proposal.length;
}

List<bool> positionsOfLetterInWord(List<String> word, String letter) {
  List<bool> matchingPositions =
      List<bool>.generate(word.length, (index) => false);
  word.asMap().forEach((i, letterToFind) {
    matchingPositions[i] = !!(letterToFind == letter);
  });
  return matchingPositions;
}

List<bool> rightPositionsMap(List<String> wordToFind, List<String> givenWord,
    String letter, int currentIndex) {
  List<bool> matchingPositions =
      List<bool>.generate(wordToFind.length, (index) => false);
  matchingPositions.asMap().forEach((i, value) {
    if (i == currentIndex) {
      matchingPositions[i] = false;
    } else {
      matchingPositions[i] =
          !!(wordToFind[i] == letter && wordToFind[i] == givenWord[i]);
    }
  });
  return matchingPositions;
}

bool letterIsWellPositionedSomewhereElse(List<String> wordToFind,
    List<String> givenWord, String letter, int currentIndex) {
  List<bool> matchingPositions =
      rightPositionsMap(wordToFind, givenWord, letter, currentIndex);

  return matchingPositions.where((element) => element == true).isEmpty
      ? false
      : true;
}

int amountOfThisLetterInRightPosition(List<String> wordToFind,
    List<String> givenWord, String letter, int currentIndex) {
  List<bool> matchingPositions =
      rightPositionsMap(wordToFind, givenWord, letter, currentIndex);
  return matchingPositions.length;
}

List<WordValidationStatus> getColorMapCorrection(
    String wordToFind, String givenWord) {
  final wordtoFindLetters = wordToFind.split('');
  final givenWordLetters = givenWord.split('');

// init everything as notInWord
  List<WordValidationStatus> statusMap = List<WordValidationStatus>.generate(
      wordtoFindLetters.length, (index) => WordValidationStatus.notInWord);

  // set all good positions
  givenWordLetters.asMap().forEach((i, letter) {
    if (letter == wordtoFindLetters[i]) {
      statusMap[i] = WordValidationStatus.goodPosition;
    }
  });

// deal with the ones that are in word but not at the good position
  givenWordLetters.asMap().forEach((i, letter) {
    if (wordtoFindLetters.contains(letter) &&
        statusMap[i] != WordValidationStatus.goodPosition) {
      int amountInWordToFind = wordtoFindLetters
          .where((letterToFind) => letterToFind == letter)
          .length;
      int amountInGivenWord = givenWordLetters
          .where((letterToFind) => letterToFind == letter)
          .length;

      if (amountInWordToFind < amountInGivenWord) {
        final positionsInGivenWord =
            positionsOfLetterInWord(givenWordLetters, letter);
        final positionsBeforeInGivenWord = positionsInGivenWord.sublist(0, i);
        final positionsAfterInGivenWord = positionsInGivenWord.sublist(i + 1);
        final amountBefore = positionsBeforeInGivenWord
            .where((element) => element == true)
            .length;
        final amountAFter = positionsAfterInGivenWord
            .where((element) => element == true)
            .length;
        if (amountBefore == 0) {
          if (letterIsWellPositionedSomewhereElse(
              wordtoFindLetters, givenWordLetters, letter, i)) {
            statusMap[i] = WordValidationStatus.ignored;
          } else {
            statusMap[i] = WordValidationStatus.wrongPosition;
          }
        } else if (amountAFter > 0) {
          if (amountBefore < amountInWordToFind) {
            statusMap[i] = WordValidationStatus.wrongPosition;
          } else {
            statusMap[i] = WordValidationStatus.ignored;
          }
        } else if (amountAFter == 0) {
          statusMap[i] = WordValidationStatus.ignored;
        }
      } else if (amountInWordToFind == amountInGivenWord) {
        if (amountOfThisLetterInRightPosition(
                wordtoFindLetters, givenWordLetters, letter, i) ==
            amountInWordToFind) {
          statusMap[i] = WordValidationStatus.ignored;
        } else {
          statusMap[i] = WordValidationStatus.wrongPosition;
        }
      } else if (amountInWordToFind > amountInGivenWord) {
        statusMap[i] = WordValidationStatus.wrongPosition;
      }
    }
  });

  return statusMap;
}

List<String> getFoundWords(
    List<String> wordsToFind, List<String>? gameInProgress) {
  return wordsToFind
      .takeWhile((wordtoFind) => gameInProgress!.contains(wordtoFind))
      .toList();
}

int getPositionOfLastFoundWord(
    List<String> wordsToFind, List<String>? gameInProgress) {
  var found = getFoundWords(wordsToFind, gameInProgress);
  if (found.isEmpty) {
    return -1;
  } else {
    int positionOfLastFound = gameInProgress!.indexOf(found.last);
    return positionOfLastFound;
  }
}

List<String> getCurrentWordConfig(
    List<String> wordsToFind, List<String>? gameInProgress) {
  if (gameInProgress == null) {
    return [];
  } else {
    if (gameInProgress.isEmpty) {
      return [];
    } else {
      int positionAfterLastFound =
          getPositionOfLastFoundWord(wordsToFind, gameInProgress);
      if (positionAfterLastFound == -1) {
        return gameInProgress;
      } else if (positionAfterLastFound + 1 > gameInProgress.length) {
        return [];
      } else {}
      var list = gameInProgress.sublist(positionAfterLastFound + 1);
      return list;
    }
  }
}
