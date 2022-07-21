import 'package:flutter/material.dart';
import 'package:motamot/gameplay/gameplay_manager.dart';
import 'package:motamot/storage/db_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const wrongWord = 'aaaaa';
const rightWord = 'arbre';

class MockOnEnterWord extends Mock {
  void call({required String word});
}

class MockOnFinish extends Mock {
  void call({
    required String word,
    required bool success,
  });
}

class MockDatabaseHandler extends Mock implements DatabaseHandler {
  @override
  Future<bool> wordExists(String word) {
    return Future.value(word == wrongWord ? false : true);
  }
}

var db = MockDatabaseHandler();

void main() {
  group('GameplayManager', () {
    group('validation', () {
      testWidgets('should show validation when word does not exist',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();

        final validationFinder =
            find.text("Ce mot n'existe pas dans notre dictionnaire.");
        expect(validationFinder, findsOneWidget);
      });
      testWidgets('should show validation when word is too short',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();

        final validationFinder = find.text("Ce mot est incorrect.");
        expect(validationFinder, findsOneWidget);
      });
      testWidgets('should disappear when delete is pressed',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();

        final validationFinder = find.text("Ce mot est incorrect.");
        expect(validationFinder, findsOneWidget);

        await tester.tap(find.byKey(const Key('KeyDelete')));
        await tester.pumpAndSettle();
        expect(validationFinder, findsNothing);
      });
      testWidgets('should disappear when a letter is pressed',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();

        final validationFinder = find.text("Ce mot est incorrect.");
        expect(validationFinder, findsOneWidget);

        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.pumpAndSettle();
        expect(validationFinder, findsNothing);
      });
    });
    group('onEnterWord', () {
      final void Function({required String word})? onEnterWord =
          MockOnEnterWord();
      testWidgets('should not be called when word is invalid',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              onEnterWord: onEnterWord,
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();
        verifyNever(onEnterWord!(word: wrongWord));
      });
      testWidgets('should be called when word is valid',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: ({
                required String word,
                required bool success,
              }) {},
              onEnterWord: onEnterWord,
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyB')));
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();
        verify(onEnterWord!(word: rightWord)).called(1);
      });
    });
    group('onFinish', () {
      final void Function({
        required String word,
        required bool success,
      }) onFinish = MockOnFinish();
      testWidgets('should not be called when word is invalid',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: onFinish,
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyA')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();
        verifyNever(onFinish(word: wrongWord, success: false));
        verifyNever(onFinish(word: wrongWord, success: true));
      });
      testWidgets('should be called with success when word is the right one',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: onFinish,
              db: db,
            )));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyB')));
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyEnter')));

        await tester.pumpAndSettle();
        verify(onFinish(word: rightWord, success: true)).called(1);
        verifyNever(onFinish(word: rightWord, success: false));
      });
      testWidgets('should be called with failure when all 6 attemps failed',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              finished: false,
              wordToFind: rightWord,
              onFinish: onFinish,
              db: db,
            )));

        await tester.pumpWidget(testWidget);

        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyS')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('KeyI')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('KeyI')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyS')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('KeyI')));
        await tester.tap(find.byKey(const Key('KeyM')));
        await tester.tap(find.byKey(const Key('KeyE')));
        await tester.tap(find.byKey(const Key('KeyR')));
        await tester.tap(find.byKey(const Key('KeyEnter')));
        await tester.pumpAndSettle();

        verify(onFinish(word: rightWord, success: false)).called(1);
        verifyNever(onFinish(word: rightWord, success: true));
      });
    });
    group('finished', () {
      testWidgets('nothing happens when tapping keyboard',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: GameplayManager(
              db: MockDatabaseHandler(),
              finished: true,
              wordToFind: 'plateau',
              onFinish: ({
                required String word,
                required bool success,
              }) {},
            )));

        await tester.pumpWidget(testWidget);

        final finishedTextFinder =
            find.text('La solution était "${"plateau".toUpperCase()}".');
        expect(finishedTextFinder, findsOneWidget);
      });
    });
  });
}
