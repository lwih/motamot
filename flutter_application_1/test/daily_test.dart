import 'package:flutter/material.dart';
import 'package:flutter_application_1/daily/daily.dart';
import 'package:flutter_application_1/daily/daily_model.dart';
import 'package:flutter_application_1/gameplay/gameplay_manager.dart';
import 'package:flutter_test/flutter_test.dart';

final Daily unstartedDaily = Daily(
  date: '2022-04-04',
  word: 'plateau',
  success: null,
  words: null,
);
final Daily finishedDaily = Daily(
  date: '2022-04-04',
  word: 'plateau',
  success: true,
  words: ['pieuvre', 'plateau'],
);

void main() {
  group('DailyWordRoute', () {
    group('unstarted', () {
      testWidgets('the Game should be shown', (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: DailyWordRoute(
              daily: unstartedDaily,
            )));
        await tester.pumpWidget(testWidget);

        final gameFinder = find.byType(GameplayManager);
        expect(gameFinder, findsOneWidget);
      });
    });
    group('finished', () {
      testWidgets('the finished text should be shown',
          (WidgetTester tester) async {
        Widget testWidget = MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
                home: DailyWordRoute(
              daily: finishedDaily,
            )));
        await tester.pumpWidget(testWidget);

        final finishedTextFinder = find
            .text('La solution était "${finishedDaily.word.toUpperCase()}".');
        expect(finishedTextFinder, findsOneWidget);
      });
    });
  });
}
