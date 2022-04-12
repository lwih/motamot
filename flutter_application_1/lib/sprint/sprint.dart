import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameplay/gameplay_manager.dart';
import 'package:flutter_application_1/sprint/sprint_instructions.dart';
import 'package:flutter_application_1/sprint/sprint_results.dart';
import 'package:flutter_application_1/home/home.dart';
import 'package:flutter_application_1/sprint/sprint_share.dart';
import 'package:flutter_application_1/sprint/sprint_utils.dart';
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
  late String? _currentWordToFind;
  late List<String> _currentWordsInProgress = [];
  late List<String> _allGivenWords;
  int _penalty = 0;
  bool _finished = false;

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
      _currentWordToFind = getCurrentWordInProgress(
        widget.sprint.words,
        widget.sprint.wordsInProgress,
      )!;
      if (_currentWordToFind == null) {
        _finished = true;
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

  void _showExplanationsOverlay(BuildContext context) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return SprintInstructions(
        onClose: () {
          overlayEntry.remove();
        },
      );
    });

    overlayState?.insert(overlayEntry);
  }

  void _showResultsOverlay(BuildContext context, {required int score}) async {
    var overlayState = Overlay.of(context);
    // ignore: prefer_typing_uninitialized_variables
    var overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        body: SprintResults(
            score: score,
            shareResults: () async {
              var a = score;
              await shareSprintResults(getScore());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                // behavior: SnackBarBehavior.fixed,
                duration: Duration(seconds: 1, milliseconds: 200),
                content: Text('Résumé copié dans le presse papier'),
              ));
            },
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
            }),
      );
    });

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);
  }

  int getScore() {
    return getFoundWords(widget.sprint.words, _allGivenWords).length - _penalty;
  }

  onFinishGame() async {
    setState(() {
      _finished = true;
    });
    _showResultsOverlay(
      context,
      score: getScore(),
    );
    try {
      await handler.updateSprintResult(
        date: formattedToday(),
        score: getScore(),
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
    String? nextWord = selectNextWord(widget.sprint.words, word);
    setState(() {
      _currentWordToFind = nextWord;
      _currentWordsInProgress = [];
    });
    try {
      if (success == false) {
        setState(() {
          _penalty++;
        });
      }
      if (nextWord == null) {
        onFinishGame();
      } else {
        await handler.updateSprintResult(
          date: formattedToday(),
          score: getScore(),
          timeLeftInSeconds: _controller.timeLeftInSeconds,
        );
      }
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
        title: const Text('Sprint'),
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
              )),
        ],
      ),
      body: Container(
        child: widget.sprint.timeLeftInSeconds == 0 || _finished == true
            ? const Center(
                child: Text(
                  'La partie est terminée.',
                  style: TextStyle(
                    fontSize: 20,
                    color: CustomColors.white,
                  ),
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
                                child: FloatingActionButton.extended(
                                  key: const Key('StartButton'),
                                  label: Text(
                                    _gamePaused &&
                                            _controller.timeLeftInSeconds ==
                                                defaultDurationInSeconds
                                        ? 'Démarrer'
                                        : 'Reprendre',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  backgroundColor: CustomColors.rightPosition,
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    onStart();
                                  },
                                ),
                                // ElevatedButton(
                                //   key: const Key('StartButton'),
                                //   onPressed: () {
                                //     onStart();
                                //   },
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       Text(
                                //         _gamePaused &&
                                //                 _controller.timeLeftInSeconds ==
                                //                     defaultDurationInSeconds
                                //             ? 'Démarrer'
                                //             : 'Reprendre',
                                //         style: const TextStyle(
                                //           fontSize: 28,
                                //         ),
                                //       ), // <-- Text
                                //       const SizedBox(
                                //         width: 2,
                                //       ),
                                //       const Icon(
                                //         Icons.play_arrow,
                                //         size: 32.0,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ),
                            )
                          : GameplayManager(
                              db: handler,
                              key: const Key('GameplayManager'),
                              wordToFind: _currentWordToFind!,
                              wordsInProgress: _currentWordsInProgress,
                              finished: false,
                              onFinish: onFinishWord,
                              onEnterWord: onEnterWord,
                            ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Score: ${getScore().toString()}',
                                style: const TextStyle(
                                  color: CustomColors.white,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Countdown(
                                controller: _controller,
                                seconds: _duration,
                                build: (BuildContext context, double time) =>
                                    Text(
                                  displayTime(time),
                                  style: const TextStyle(
                                    color: CustomColors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                interval: const Duration(seconds: 1),
                                onFinished: () async {
                                  await onFinishGame();
                                },
                              ),
                              IconButton(
                                iconSize: 30,
                                splashRadius: 32,
                                color: _gamePaused
                                    ? CustomColors.backgroundColor
                                    : CustomColors.white,
                                icon: const Icon(Icons.pause),
                                key: const Key('PauseButton'),
                                onPressed: () {
                                  onPause();
                                },
                              )
                            ],
                          )
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
