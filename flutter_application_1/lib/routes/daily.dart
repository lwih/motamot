import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameplay/gameplay_manager.dart';
import 'package:flutter_application_1/storage/daily.dart';
import 'package:flutter_application_1/storage/db-handler.dart';
import 'package:flutter_application_1/design/design.dart';
import 'package:flutter_application_1/modals/daily_results.dart';
import 'package:flutter_application_1/utils/date_utils.dart';

import '../utils/date_utils.dart';

class DailyWordRoute extends StatefulWidget {
  final Daily daily;
  const DailyWordRoute({required this.daily, Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<DailyWordRoute> createState() => _DailyWordRouteState();
}

class _DailyWordRouteState extends State<DailyWordRoute>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late DatabaseHandler handler;

  late List<String> _wordsInProgress;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler('motus.db');

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    setState(() {
      _wordsInProgress = widget.daily.words ?? [];
    });
  }

  Future<Daily> dailyChallenge() async {
    final Daily dailyChallenge =
        await handler.retrieveDailyChallenge(formattedToday());
    return dailyChallenge;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context,
      {required bool success, required String word}) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return DailyResults(
          wordToFind: word,
          success: success,
          shareResults: () {},
          goHome: () {
            overlayEntry.remove();
            Navigator.pop(context);
          });
    });

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);
  }

  onFinish({
    required String word,
    required bool success,
  }) async {
    _showOverlay(
      context,
      success: true,
      word: word,
    );
    var a = await handler.updateDailyResult(
      date: formattedToday(),
      success: success,
    );
  }

  onEnterWord({required String word}) async {
    final List<String> allWords = [..._wordsInProgress, word];
    var a = await handler.updateDailyWordsInProgress(
      date: formattedToday(),
      words: allWords,
    );
    setState(() {
      _wordsInProgress = allWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dailyWord = widget.daily.word.toString();
    final bool finished = widget.daily.success != null;
    // Build the widget with data.
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        appBar: AppBar(
          // Here we take the value from the Daily object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Le mot du jour'),
          backgroundColor: CustomColors.backgroundColor,
        ),
        body: Container(
          margin: EdgeInsets.all(dailyWord.length > 6 ? 10 : 30),
          child: GameplayManager(
            wordToFind: dailyWord,
            wordsInProgress: _wordsInProgress,
            finished: finished,
            onFinish: onFinish,
            onEnterWord: onEnterWord,
          ),
        ));
  }
}
