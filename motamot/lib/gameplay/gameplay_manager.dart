import 'dart:async';
import 'package:flutter/material.dart';
import 'package:motamot/storage/db_handler.dart';
import 'package:motamot/ui/design.dart';
import 'package:sizer/sizer.dart';
import 'grid/grid.dart';
import 'keyboard/keyboard.dart';

class GameplayManager extends StatefulWidget {
  final DatabaseHandler db;
  final String wordToFind;
  final List<String>? wordsInProgress;
  final bool finished;
  final void Function({
    required String word,
    required bool success,
  }) onFinish;
  final void Function({required String word})? onEnterWord;

  const GameplayManager(
      {required this.db,
      required this.wordToFind,
      this.wordsInProgress,
      required this.finished,
      required this.onFinish,
      this.onEnterWord,
      Key? key})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<GameplayManager> createState() => _GameplayManagerState();
}

class _GameplayManagerState extends State<GameplayManager>
    with TickerProviderStateMixin {
  late String _firstLetter;
  late String _wordInProgress;
  late List<String> _wordsInProgress;
  String _validation = '';
  bool _finished = false;
  late AnimationController animationController;

  void setInitialValues() {
    setState(() {
      _firstLetter = widget.wordToFind.split('').first;
      _wordInProgress = widget.wordToFind.split('').first;
      _wordsInProgress = [...?widget.wordsInProgress];
      _finished = widget.finished;
      _validation = widget.finished
          ? 'La solution était "${widget.wordToFind.toUpperCase()}".'
          : '';
    });
  }

  @override
  void initState() {
    super.initState();

    setInitialValues();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(GameplayManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wordToFind != oldWidget.wordToFind) {
      setInitialValues();
    }
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
      if (_wordInProgress.length != widget.wordToFind.length) {
        setState(() {
          _validation = "Ce mot est incorrect.";
        });
      } else {
        bool wordExists = await widget.db.wordExists(_wordInProgress);
        // bool wordExists = true;
        if (wordExists) {
          await _playAnimation();

          setState(() {
            _wordsInProgress.add(_wordInProgress);

            // custom behaviour optionally defined by parent widget
            if (widget.onEnterWord != null) {
              widget.onEnterWord!(word: _wordInProgress);
            }

            if (_wordInProgress == widget.wordToFind) {
              _finished = true;
            } else {
              if (_wordsInProgress.length == 6) {
                _finished = true;
                _wordInProgress = '';
              } else {
                _wordInProgress = _firstLetter;
              }
            }
          });

          if (_wordInProgress == widget.wordToFind) {
            widget.onFinish(
              word: widget.wordToFind,
              success: true,
            );
          } else {
            if (_wordsInProgress.length == 6) {
              widget.onFinish(
                word: widget.wordToFind,
                success: false,
              );
            }
          }
        } else {
          setState(() {
            _validation = "Ce mot n'existe pas dans notre dictionnaire.";
          });
        }
      }
    }

    if (key != 'delete' &&
        key != 'enter' &&
        _wordInProgress.length < widget.wordToFind.length) {
      setState(() {
        _validation = '';
        _wordInProgress = '$_wordInProgress$key';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Center(
        //   child: Text('word: ${widget.wordToFind}'),
        // ),
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Center(
            child: Keyboard(
              rightPositionKeys:
                  getRightPositionKeys(widget.wordToFind, _wordsInProgress),
              wrongPositionKeys:
                  getWrongPositionKeys(widget.wordToFind, _wordsInProgress),
              disableKeys: getDisabledKeys(widget.wordToFind, _wordsInProgress),
              chooseKey: _onChooseKey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(
              _validation,
              style: TextStyle(
                color: CustomColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: WordGrid(
              animationController: animationController,
              finished: _finished,
              numberOfRows: 6,
              firstLetter: widget.wordToFind.substring(0, 1),
              words: _wordsInProgress,
              wordInProgress: _wordInProgress,
              hints: hints(widget.wordToFind, _wordsInProgress),
              showHints: _finished
                  ? false
                  : showHints(
                      widget.wordToFind, _wordInProgress, _wordsInProgress),
              wordToFind: widget.wordToFind,
            ),
          ),
        ),
      ],
    );
  }
}
