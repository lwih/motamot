import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameplay/grid.dart';
import 'package:flutter_application_1/gameplay/keyboard.dart';
import 'dart:developer' as developer;

import 'package:flutter_application_1/utils.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final String _wordToFind = 'prout';
  String firstLetter = 'p';
  String _wordInProgress = 'p';
  final List<String> _words = [];
  String _validation = '';
  bool _finished = false;

  void _onChooseKey(String key) {
    setState(() {
      developer.log(key);
      _validation = '';
      if (_finished) {
      } else if (_wordInProgress.length == _wordToFind.length &&
          !(key == 'enter' || key == 'delete')) {
      } else if (key == 'delete' && _wordInProgress.isNotEmpty) {
        _wordInProgress =
            _wordInProgress.substring(0, _wordInProgress.length - 1);
      } else if (key == 'enter') {
        if (wordHasCorrectLength(_wordToFind, _wordInProgress) &&
            wordIsAcceptable(_wordInProgress)) {
          _words.add(_wordInProgress);
          _wordInProgress = firstLetter;

          if (_words.length == 6) {
            _finished = true;
            _wordInProgress = '';
          }
        } else {
          _validation = 'word not acceptable';
        }
      } else if (key != 'delete' && key != 'enter') {
        _wordInProgress = '$_wordInProgress$key';
      }
    });
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the DailyPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('TITLE'),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text('word: $_wordToFind'),
              ),
              Center(
                child: Text('finished: $_finished'),
              ),
              Center(
                child: WordGrid(
                  numberOfRows: 6,
                  firstLetter: _wordToFind.substring(0, 1),
                  words: _words,
                  wordInProgress: _wordInProgress,
                  hints: hints(_wordToFind, _words),
                  showHints: showHints(_wordToFind, _wordInProgress, _words),
                  wordToFind: _wordToFind,
                  activeRow: 0,
                ),
              ),
              Center(
                child: Keyboard(
                  chooseKey: _onChooseKey,
                ),
              ),
              Center(
                child: Text(_validation),
              ),
            ],
          ),
        ));
  }
}
