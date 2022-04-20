List<String> getFoundWords(
    List<String> wordsToFind, List<String>? gameInProgress) {
  return wordsToFind
      .where((wordtoFind) => gameInProgress!.contains(wordtoFind))
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

String? selectNextWord(List<String> wordsToFind, String? lastFoundWord) {
  if (lastFoundWord == null) {
    return wordsToFind.first;
  }
  int postOfLastFound = wordsToFind.indexOf(lastFoundWord);
  if (wordsToFind.length > postOfLastFound + 1) {
    return wordsToFind.elementAt(postOfLastFound + 1);
  } else {
    return null;
  }
}

String? getCurrentWordInProgress(
    List<String> wordsToFind, List<String>? gameInProgress) {
  if (gameInProgress == null || gameInProgress.isEmpty) {
    return wordsToFind.first;
  }
  int positionOfLastFoundWord = getPositionOfLastFoundWord(
    wordsToFind,
    gameInProgress,
  );
  if ((positionOfLastFoundWord == -1)) {
    return wordsToFind.first;
  } else {
    var wordsInProgressSinceLastFound =
        gameInProgress.sublist(positionOfLastFoundWord + 1);
    if (wordsInProgressSinceLastFound.length > 5) {
      // that means there we some failures so we need to get the last failed word
      int amountOfFailedWords = wordsInProgressSinceLastFound.length % 6 == 0
          ? 1
          : wordsInProgressSinceLastFound.length % 6;
      int pos = wordsToFind
              .indexOf(gameInProgress.elementAt(positionOfLastFoundWord)) +
          amountOfFailedWords +
          1;
      String nextWord = wordsToFind.elementAt(pos);
      return nextWord;
    } else {
      return selectNextWord(
        wordsToFind,
        gameInProgress.elementAt(positionOfLastFoundWord),
      );
    }
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
      int positionOfLastFoundWord =
          getPositionOfLastFoundWord(wordsToFind, gameInProgress);
      if (positionOfLastFoundWord == -1) {
        return gameInProgress;
      } else if (positionOfLastFoundWord + 1 > gameInProgress.length) {
        return [];
      } else {
        var list = gameInProgress.sublist(positionOfLastFoundWord + 1);
        if (list.length > 5) {
          int amountOfFailedWords = list.length % 6;
          int startPosition =
              positionOfLastFoundWord + 1 + (amountOfFailedWords * 6);
          var newerList = gameInProgress.sublist(startPosition);
          return newerList.length == 6 ? [] : newerList;
        } else {
          return list;
        }
      }
    }
  }
}
