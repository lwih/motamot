import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameplay/gameplay_manager.dart';
import 'package:flutter_application_1/sprint/sprint_results.dart';
import 'package:flutter_application_1/home/home.dart';
import 'package:flutter_application_1/storage/db_handler.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/utils/date_utils.dart';

import '../ui/countdown/countdown.dart';
import '../ui/countdown/countdown_controller.dart';
import '../ui/route/fade_route.dart';
import '../utils/date_utils.dart';

class SprintWordRoute extends StatefulWidget {
  final Sprint sprint;
  const SprintWordRoute({required this.sprint, Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SprintWordRoute> createState() => _SprintWordRouteState();
}

class _SprintWordRouteState extends State<SprintWordRoute>
    with TickerProviderStateMixin {
  static const int defaultDurationInSeconds = 5 * 60;
  late AnimationController animationController;

  late DatabaseHandler handler;
  late CountdownController _controller;

  late bool _gamePaused = true;
  late int _duration;
  late String _currentWordToFind;
  late List<String> _currentWordsInProgress = [];
  late List<String> _allGivenWords;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler('motus.db');
    int timeLeftInSeconds =
        widget.sprint.timeLeftInSeconds ?? defaultDurationInSeconds;
    _controller = CountdownController(
      autoStart: false,
      timeLeftInSeconds: timeLeftInSeconds,
    );

    setState(() {
      if (widget.sprint.wordsInProgress == null) {
        _currentWordToFind = widget.sprint.words.first;
      } else {
        int positionOfLastFoundWord = getPositionOfLastFoundWord(
          widget.sprint.words,
          widget.sprint.wordsInProgress,
        );
        if ((positionOfLastFoundWord == -1 &&
                widget.sprint.wordsInProgress != null) ||
            widget.sprint.wordsInProgress == null) {
          _currentWordToFind = widget.sprint.words.first;
        } else {
          _currentWordToFind = selectNextWord(
            widget.sprint.words,
            widget.sprint.wordsInProgress!.elementAt(
              getPositionOfLastFoundWord(
                widget.sprint.words,
                widget.sprint.wordsInProgress,
              ),
            ),
          );
        }
      }

      _currentWordsInProgress = getCurrentWordConfig(
        widget.sprint.words,
        widget.sprint.wordsInProgress,
      );
      _allGivenWords = widget.sprint.wordsInProgress ?? [];
      _duration = timeLeftInSeconds;
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  Future<Sprint> dailyChallenge() async {
    final Sprint dailyChallenge =
        await handler.retrieveSprintChallenge(formattedToday());
    return dailyChallenge;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void onStart() {
    _controller.resume();
    setState(() {
      _gamePaused = false;
    });
  }

  void onPause() {
    _controller.pause();
    setState(() {
      _gamePaused = true;
    });
  }

  String selectNextWord(List<String> wordsToFind, String lastFoundWord) {
    return wordsToFind[wordsToFind.indexOf(lastFoundWord) + 1];
  }

  void _showOverlay(BuildContext context, {required int score}) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return SprintResults(
          score: score,
          shareResults: () {},
          goHome: () {
            overlayEntry.remove();

            // .pop() will not refresh the FutureBuilders in Home()
            // pushAndRemoveUntil() make it word
            Navigator.pushAndRemoveUntil(
              context,
              FadeRoute(
                page: const Home(),
              ),
              (Route<dynamic> route) => false,
            );
          });
    });

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);
  }

  onFinishGame() async {
    int score = getFoundWords(widget.sprint.words, _allGivenWords).length;
    _showOverlay(
      context,
      score: score,
    );
    try {
      await handler.updateSprintResult(
        date: formattedToday(),
        score: score,
        timeLeftInSeconds: 0,
      );
    } catch (e) {
      log('error onFinishGame updateSprintResult', error: e);
    }
  }

  onFinishWord({
    required String word,
    required bool success,
  }) async {
    setState(() {
      String nextWord = selectNextWord(widget.sprint.words, word);
      _currentWordToFind = nextWord;
      _currentWordsInProgress = [];
    });
    try {
      await handler.updateSprintResult(
        date: formattedToday(),
        score: getFoundWords(widget.sprint.words, _allGivenWords).length,
        timeLeftInSeconds: _controller.timeLeftInSeconds,
      );
    } catch (e) {
      log('error onFinishWord updateSprintResult', error: e);
    }
  }

  onEnterWord({required String word}) async {
    List<String> allWords = [..._allGivenWords, word];
    setState(() {
      _allGivenWords = allWords;
      _currentWordsInProgress = [..._currentWordsInProgress, word];
    });

    try {
      await handler.updateSprintWordsInProgress(
        date: formattedToday(),
        words: allWords,
        timeLeftInSeconds: _controller.timeLeftInSeconds,
      );
    } catch (e) {
      log('error onEnterWord updateSprintWordsInProgress', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        // Here we take the value from the Sprint object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Sprint du dimanche'),
        backgroundColor: CustomColors.backgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.all(_currentWordToFind.length > 6 ? 10 : 30),
        child: widget.sprint.timeLeftInSeconds == 0
            ? Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('ITS FINISHED'),
                ),
              )
            : Center(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    Expanded(
                      child: _gamePaused
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: ElevatedButton(
                                  key: const Key('StartButton'),
                                  child: Text(_gamePaused &&
                                          _controller.timeLeftInSeconds ==
                                              defaultDurationInSeconds
                                      ? 'Démarrer'
                                      : 'Reprendre'),
                                  onPressed: () {
                                    onStart();
                                  },
                                ),
                              ),
                            )
                          : GameplayManager(
                              db: handler,
                              key: const Key('GameplayManager'),
                              wordToFind: _currentWordToFind,
                              wordsInProgress: _currentWordsInProgress,
                              finished: false,
                              onFinish: onFinishWord,
                              onEnterWord: onEnterWord,
                            ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Countdown(
                            controller: _controller,
                            seconds: _duration,
                            build: (BuildContext context, double time) => Text(
                              displayTime(time),
                              style: const TextStyle(color: CustomColors.white),
                            ),
                            interval: const Duration(seconds: 1),
                            onFinished: () async {
                              await onFinishGame();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Pause'),
                            onPressed: () {
                              onPause();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
