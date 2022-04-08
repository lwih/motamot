import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/sprint/sprint_utils.dart';

void main() {
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
    test(
        'should return [] when last attempt was a failure and no attempt on newer word',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx'
      ];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), []);
    });
    test(
        'should return [wordY] when last attempt was a failure and newer word in progress',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordy',
      ];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress), ['wordy']);
    });
    test(
        'should return [wordY,wordY] when previous attempts were a failure and newer word in progress',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordy',
        'wordy',
      ];
      expect(getCurrentWordConfig(wordsToFind, gameInProgress),
          ['wordy', 'wordy']);
    });
    test(
        'should return the words after the last word found if no failure inbetween',
        () {
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

  group('getCurrentWordInProgress', () {
    const List<String> wordsToFind = [
      'word1',
      'word2',
      'word3',
      'word4',
      'word5'
    ];
    test('should return the first when gameInProgress is null', () {
      const List<String>? gameInProgress = null;
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress),
          wordsToFind.first);
    });
    test('should return the first when gameInProgress is empty', () {
      const List<String>? gameInProgress = [];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress),
          wordsToFind.first);
    });
    test('should return the first when none found yet but some exist', () {
      const List<String>? gameInProgress = ['other'];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress),
          wordsToFind.first);
    });
    test(
        'should return the next one when some words have been found but nothing new after',
        () {
      const List<String>? gameInProgress = ['wordX', 'wordX', 'wordX', 'word1'];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress), 'word2');
    });
    test(
        'should return the 2nd after when last attempt was a failure and no attempt on newer word',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx'
      ];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress), 'word3');
    });
    test(
        'should return the 3rd when last attempt was a failure and newer word in progress',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordy',
      ];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress), 'word3');
    });
    test(
        'should returnthe 4th when previous attempts were a failure and newer word in progress',
        () {
      const List<String>? gameInProgress = [
        'word1',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordx',
        'wordy',
        'wordy',
      ];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress), 'word4');
    });
    test(
        'should return the words after the last word found if no failure inbetween',
        () {
      const List<String>? gameInProgress = [
        'wordX',
        'wordX',
        'wordX',
        'word1',
        'wordx'
      ];
      expect(getCurrentWordInProgress(wordsToFind, gameInProgress), 'word2');
    });
  });
  group('selectNextWord', () {
    test('should return null when last found is last available', () {
      final words = ['word1', 'word2'];
      const lastFound = 'word2';
      expect(selectNextWord(words, lastFound), null);
    });
    test('should return the first when last found is null', () {
      final words = ['word1', 'word2'];
      const lastFound = null;
      expect(selectNextWord(words, lastFound), words.first);
    });
    test('should return the next word', () {
      final words = ['word1', 'word2'];
      const lastFound = 'word1';
      expect(selectNextWord(words, lastFound), 'word2');
    });
  });
}
