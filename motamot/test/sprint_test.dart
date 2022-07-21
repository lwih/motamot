import 'package:flutter/material.dart';
import 'package:motamot/gameplay/gameplay_manager.dart';
import 'package:motamot/sprint/sprint.dart';
import 'package:motamot/sprint/sprint_model.dart';
import 'package:flutter_test/flutter_test.dart';

final Sprint unstartedSprint = Sprint(
  date: '2022-04-04',
  words: [
    'word11',
    'word22',
  ],
  score: null,
  wordsInProgress: null,
  timeLeftInSeconds: null,
);

void main() {
  group('SprintWordRoute', () {
    group('unstarted', () {
      testWidgets('the "Démarrer" button should be shown',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(2000, 2000);
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(size: Size.fromHeight(1000)),
            child: MaterialApp(
                home: SprintWordRoute(
              sprint: unstartedSprint,
            )));
        await tester.pumpWidget(testWidget);
        final startButtonFinder = find.byKey(const Key('StartButton'));
        expect(startButtonFinder, findsOneWidget);
      });
      testWidgets('the Game should not be shown', (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: SprintWordRoute(
              sprint: unstartedSprint,
            )));
        await tester.pumpWidget(testWidget);
        final gameFinder = find.byType(GameplayManager);
        expect(gameFinder, findsNothing);
      });

      testWidgets('it should show the Game after tapping Démarrer',
          (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(2000, 2000);
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(size: Size.fromHeight(1000)),
            child: MaterialApp(
                home: SprintWordRoute(
              sprint: unstartedSprint,
            )));
        await tester.pumpWidget(testWidget);
        final startButtonFinder = find.byKey(const Key('StartButton'));
        expect(startButtonFinder, findsOneWidget);
        await tester.tap(startButtonFinder);
        await tester.pumpAndSettle();
        final gameFinder = find.byType(GameplayManager);
        expect(gameFinder, findsOneWidget);
        expect(startButtonFinder, findsNothing);
      });
    });
  });
}
