import 'dart:async';
import 'dart:developer';

import 'package:flutter_application_1/grid/grid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/DatabaseHandler.dart';
import 'package:flutter_application_1/design/design.dart';
import 'package:flutter_application_1/keyboard/keyboard.dart';
import 'package:flutter_application_1/modals/daily_results.dart';
import 'package:flutter_application_1/routes/home.dart';
import 'package:flutter_application_1/utils/date_utils.dart';
import 'package:intl/intl.dart';

import '../utils/date_utils.dart';

class DailyRoute extends StatefulWidget {
  const DailyRoute({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<DailyRoute> createState() => _DailyRouteState();
}

class _DailyRouteState extends State<DailyRoute> with TickerProviderStateMixin {
  late String _wordToFind;
  late String _firstLetter;
  late String _wordInProgress = 'e';
  final List<String> _words = [];
  String _validation = '';
  bool _finished = false;
  late AnimationController animationController;

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler('motus.db');

    getDailyWord();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void getDailyWord() async {
    final String word = await handler.retrieveDailyWord(formattedToday());

    setState(() {
      _wordToFind = word;
      _firstLetter = word.split('').first;
      _wordInProgress = _firstLetter;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await animationController.forward().orCancel;
      animationController.reset();
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  String hints(String wordToFind, List<String> words) {
    List<String> wordInProgress = List.generate(
        wordToFind.length, (index) => index == 0 ? wordToFind[0] : ' ');

    for (String word in words) {
      word.split('').asMap().forEach((int pos, String letter) {
        if (wordToFind[pos] == letter) {
          wordInProgress[pos] = letter;
        }
      });
    }
    return wordInProgress.join('');
  }

  bool showHints(
          String wordToFind, String wordInProgress, List<String> words) =>
      wordInProgress[0] == wordToFind[0] && wordInProgress.length == 1;

  List<String> getRightPositionKeys(String wordToFind, List<String> words) {
    List<String> keys = [];
    for (String word in words) {
      word.split('').asMap().forEach((int pos, String letter) {
        if (wordToFind[pos] == letter) {
          keys.add(letter);
        }
      });
    }
    return keys;
  }

  List<String> getWrongPositionKeys(String wordToFind, List<String> words) {
    List<String> keys = [];
    for (String word in words) {
      word.split('').asMap().forEach((int pos, String letter) {
        if (wordToFind.contains(letter) && wordToFind[pos] != letter) {
          keys.add(letter);
        }
      });
    }
    return keys;
  }

  List<String> getDisabledKeys(String wordToFind, List<String> words) {
    List<String> keys = [];
    for (String word in words) {
      word.split('').asMap().forEach((int pos, String letter) {
        if (!wordToFind.contains(letter)) {
          keys.add(letter);
        }
      });
    }
    return keys;
  }

  @override
  Widget build(BuildContext context) {
    void _showOverlay(BuildContext context, {required bool success}) async {
      // Declaring and Initializing OverlayState
      // and OverlayEntry objects
      var overlayState = Overlay.of(context);
      // ignore: prefer_typing_uninitialized_variables
      var overlayEntry;
      overlayEntry = OverlayEntry(builder: (context) {
        return DailyResults(
            wordToFind: _wordToFind,
            success: success,
            shareResults: () {},
            goHome: () {
              overlayEntry.remove();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            });
      });

      // Inserting the OverlayEntry into the Overlay
      overlayState?.insert(overlayEntry);
    }

    void _onChooseKey(String key) async {
      if (_finished) {
        return;
      }

      if (key == 'delete' && _wordInProgress.length > 1) {
        return setState(() {
          _wordInProgress =
              _wordInProgress.substring(0, _wordInProgress.length - 1);
          _validation = "";
        });
      }

      if (key == 'enter') {
        // incorrect length
        if (_wordInProgress.length != _wordToFind.length) {
          setState(() {
            _validation = "Ce mot n'est pas correct.";
          });
        }

        bool wordExists = await handler.wordExists(_wordInProgress);

        if (wordExists) {
          await _playAnimation();

          if (_wordInProgress == _wordToFind) {
            _showOverlay(context, success: true);
            var a = await handler.updateDailyResult(
              date: formattedToday(),
              success: true,
              attempts: (_words.length + 1),
            );
          } else {
            if (_words.length == 5) {
              _showOverlay(context, success: false);
              var a = await handler.updateDailyResult(
                date: formattedToday(),
                success: false,
                attempts: (_words.length + 1),
              );
              log('ok');
            }
          }

          setState(() {
            if (_wordInProgress == _wordToFind) {
              _finished = true;
              // _showOverlay(context, success: true);
              // var a = await handler.updateDailyResult(
              //   date: formattedToday(),
              //   success: true,
              //   attempts: (_words.length + 1),
              // );
              // log('ok');
            } else {
              _words.add(_wordInProgress);

              if (_words.length == 6) {
                _finished = true;
                _wordInProgress = '';
                // _showOverlay(context, success: false);
                // var a = await handler.updateDailyResult(
                //   date: formattedToday(),
                //   success: false,
                //   attempts: (_words.length + 1),
                // );
                // log('ok');
              } else {
                _wordInProgress = _firstLetter;
              }
            }
          });
        } else {
          setState(() {
            _validation = "Ce mot n'existe pas dans notre dictionnaire.";
          });
        }
      }

      if (key != 'delete' &&
          key != 'enter' &&
          _wordInProgress.length < _wordToFind.length) {
        setState(() {
          _validation = '';
          _wordInProgress = '$_wordInProgress$key';
        });
      }
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        appBar: AppBar(
          // Here we take the value from the Daily object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Le mot du jour'),
          backgroundColor: CustomColors.backgroundColor,
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text('word: $_wordToFind'),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: WordGrid(
                    animationController: animationController,
                    numberOfRows: 6,
                    firstLetter: _wordToFind.substring(0, 1),
                    words: _words,
                    wordInProgress: _wordInProgress,
                    hints: hints(_wordToFind, _words),
                    showHints: _finished
                        ? false
                        : showHints(_wordToFind, _wordInProgress, _words),
                    wordToFind: _wordToFind,
                  ),
                ),
              ),
              Center(
                child: Text(
                  _validation,
                  style: const TextStyle(
                      color: CustomColors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Keyboard(
                  rightPositionKeys: getRightPositionKeys(_wordToFind, _words),
                  wrongPositionKeys: getWrongPositionKeys(_wordToFind, _words),
                  disableKeys: getDisabledKeys(_wordToFind, _words),
                  chooseKey: _onChooseKey,
                ),
              ),
            ],
          ),
        ));
  }
}
