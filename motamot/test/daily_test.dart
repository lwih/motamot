import 'package:flutter/material.dart';
import 'package:motamot/daily/daily.dart';
import 'package:motamot/daily/daily_model.dart';
import 'package:motamot/gameplay/gameplay_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'component_wrapper.dart';

final Daily unstartedDaily = Daily(
  id: 1,
  date: '2022-04-04',
  word: 'plateau',
  success: null,
  words: null,
);
final Daily finishedDaily = Daily(
  id: 1,
  date: '2022-04-04',
  word: 'plateau',
  success: true,
  words: ['pieuvre', 'plateau'],
);

void main() {
  group('DailyWordRoute', () {
    group('unstarted', () {
      testWidgets(
        'the Game should be shown',
        (WidgetTester tester) async {
          Widget testWidget = wrapped(DailyWordRoute(
            daily: unstartedDaily,
          ));

          await tester.pumpWidget(testWidget);

          final gameFinder = find.byType(GameplayManager);
          expect(gameFinder, findsOneWidget);
        },
      );
    });
    group('finished', () {
      testWidgets('the finished text should be shown',
          (WidgetTester tester) async {
        Widget testWidget = wrapped(DailyWordRoute(
          daily: finishedDaily,
        ));
        await tester.pumpWidget(testWidget);

        final finishedTextFinder = find
            .text('La solution était "${finishedDaily.word.toUpperCase()}".');
        expect(finishedTextFinder, findsOneWidget);
      });
    });
  });
}
