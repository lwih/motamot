import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/daily/daily_instructions.dart';
import 'package:flutter_application_1/daily/daily_share.dart';
import 'package:flutter_application_1/gameplay/gameplay_manager.dart';
import 'package:flutter_application_1/daily/daily_model.dart';
import 'package:flutter_application_1/home/home.dart';
import 'package:flutter_application_1/storage/db_handler.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:flutter_application_1/ui/route/fade_route.dart';
import 'package:flutter_application_1/utils/date_utils.dart';

import '../utils/date_utils.dart';
import 'daily_results.dart';

class DailyWordRoute extends StatefulWidget {
  final Daily daily;
  const DailyWordRoute({required this.daily, Key? key}) : super(key: key);

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

  void _showExplanationsOverlay(BuildContext context) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return DailyInstructions(
        onClose: () {
          overlayEntry.remove();
        },
      );
    });

    overlayState?.insert(overlayEntry);
  }

  void _showResultsOverlay(
    BuildContext context, {
    required bool success,
    required String word,
  }) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        body: DailyResults(
            wordToFind: word,
            success: success,
            shareResults: () async {
              await shareDailyResults(
                Daily(
                  id: 123,
                  date: formattedToday(),
                  word: widget.daily.word,
                  success: success,
                  words: _wordsInProgress,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                // behavior: SnackBarBehavior.fixed,
                duration: Duration(seconds: 1, milliseconds: 200),
                content: Text('Résumé copié dans le presse papier'),
              ));
            },
            goHome: () {
              // .pop() will not refresh the FutureBuilders in Home()
              // pushAndRemoveUntil() make it word
              Navigator.pushAndRemoveUntil(
                context,
                FadeRoute(
                  page: const Home(),
                ),
                (Route<dynamic> route) => false,
              );
              overlayEntry.remove();
            }),
      );
    });

    overlayState?.insert(overlayEntry);
  }

  onFinish({
    required String word,
    required bool success,
  }) async {
    _showResultsOverlay(
      context,
      success: success,
      word: word,
    );
    try {
      await handler.updateDailyResult(
        date: formattedToday(),
        success: success,
      );
    } catch (e) {
      log('error onFinish updateDailyResult', error: e);
    }
  }

  onEnterWord({required String word}) async {
    final List<String> allWords = [..._wordsInProgress, word];
    try {
      await handler.updateDailyWordsInProgress(
        date: formattedToday(),
        words: allWords,
      );
    } catch (e) {
      log('error onEnterWord updateDailyWordsInProgress', error: e);
    }

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _showExplanationsOverlay(context);
              },
              child: const Icon(
                Icons.info_outline,
                color: CustomColors.hintText,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GameplayManager(
          db: handler,
          wordToFind: dailyWord,
          wordsInProgress: _wordsInProgress,
          finished: finished,
          onFinish: onFinish,
          onEnterWord: onEnterWord,
        ),
      ),
    );
  }
}
