import 'package:flutter_application_1/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('letterIsWellPositionedSomewhereElse', () {
    test('case not found: [prout - puuot - o - 3]', () {
      final wordToFind = 'prout'.split('');
      final givenWord = 'puuut'.split('');
      const letter = 'o';
      const index = 3;
      expect(
          letterIsWellPositionedSomewhereElse(
              wordToFind, givenWord, letter, index),
          false);
    });
    test('case found at other position: [prout - prout - o - 3]', () {
      final wordToFind = 'prout'.split('');
      final givenWord = 'prout'.split('');
      const letter = 'o';
      const index = 3;
      expect(
          letterIsWellPositionedSomewhereElse(
              wordToFind, givenWord, letter, index),
          true);
    });
    test('case found at same position: [prout - prout - o - 4]', () {
      final wordToFind = 'prout'.split('');
      final givenWord = 'prout'.split('');
      const letter = 'o';
      const index = 2;
      expect(
          letterIsWellPositionedSomewhereElse(
              wordToFind, givenWord, letter, index),
          false);
    });
    test('case not found at right position: [prout - puuot - u - 1]', () {
      final wordToFind = 'prout'.split('');
      final givenWord = 'puuot'.split('');
      const letter = 'u';
      const index = 1;
      expect(
          letterIsWellPositionedSomewhereElse(
              wordToFind, givenWord, letter, index),
          false);
    });
    test('case found at right position: [prout - puuot - u - 1]', () {
      final wordToFind = 'prout'.split('');
      final givenWord = 'puuut'.split('');
      const letter = 'u';
      const index = 1;
      expect(
          letterIsWellPositionedSomewhereElse(
              wordToFind, givenWord, letter, index),
          true);
    });
  });
  group('color correction', () {
    test('prout - puuut = [oiioo]', () {
      const wordToFind = 'prout';
      const givenWord = 'puuut';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.ignored,
        WordValidationStatus.ignored,
        WordValidationStatus.goodPosition,
        WordValidationStatus.goodPosition
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('prout - puuot = [ouiuo]', () {
      const wordToFind = 'prout';
      const givenWord = 'puuot';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.ignored,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.goodPosition
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('poter - petee - [oiooi]', () {
      const wordToFind = 'poter';
      const givenWord = 'petee';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.ignored,
        WordValidationStatus.goodPosition,
        WordValidationStatus.goodPosition,
        WordValidationStatus.ignored
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('poter - peete - [ouiui]', () {
      const wordToFind = 'poter';
      const givenWord = 'peete';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.ignored,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.ignored
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('peeti - pomte - [oxxou]', () {
      const wordToFind = 'peeti';
      const givenWord = 'pomte';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.notInWord,
        WordValidationStatus.notInWord,
        WordValidationStatus.goodPosition,
        WordValidationStatus.wrongPosition
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('peeti - pomte - [oxxou]', () {
      const wordToFind = 'peeti';
      const givenWord = 'pomte';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.notInWord,
        WordValidationStatus.notInWord,
        WordValidationStatus.goodPosition,
        WordValidationStatus.wrongPosition
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
    test('expert - entier - [oxuxuu]', () {
      const wordToFind = 'expert';
      const givenWord = 'entier';
      final expectedResult = [
        WordValidationStatus.goodPosition,
        WordValidationStatus.notInWord,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.notInWord,
        WordValidationStatus.wrongPosition,
        WordValidationStatus.wrongPosition
      ];
      final actualResult = getColorMapCorrection(wordToFind, givenWord);
      expect(actualResult, expectedResult);
    });
  });
  group('getCurrentWordConfig', () {
    const List<String> wordsToFind = [
      'word1',
      'word2',
      'word3',
      'word4',
      'word5'
    ];
    test('should return [] when gameInProgress is null', () {
      const List<String>? gameInProgress = null;
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), []);
    });
    test('should return [] when gameInProgress is empty', () {
      const List<String>? gameInProgress = [];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), []);
    });
    test('should return wordInProgress when none found yet but some exist', () {
      const List<String>? gameInProgress = ['other'];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), gameInProgress);
    });
    test(
        'should return [] when some words have been found but nothing new after',
        () {
      const List<String>? gameInProgress = ['wordX', 'wordX', 'wordX', 'word1'];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), []);
    });
    test('should return the words after the last word found', () {
      const List<String>? gameInProgress = [
        'wordX',
        'wordX',
        'wordX',
        'word1',
        'wordx'
      ];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), ['wordx']);
    });
  });
}
