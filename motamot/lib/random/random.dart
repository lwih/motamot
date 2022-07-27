import 'package:motamot/gameplay/gameplay_manager.dart';
import 'package:flutter/material.dart';
import 'package:motamot/storage/db_handler.dart';
import 'package:motamot/ui/design.dart';

import '../daily/daily_results.dart';

class RandomWordRoute extends StatefulWidget {
  const RandomWordRoute({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<RandomWordRoute> createState() => _RandomWordRouteState();
}

class _RandomWordRouteState extends State<RandomWordRoute>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler('motamot.db');

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context,
      {required bool success, required String word}) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
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

  onFinish({required String word, required bool success}) async {
    _showOverlay(context, success: true, word: word);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: handler.retrieveRandomWord(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final randomWord = snapshot.data.toString();
            // Build the widget with data.
            return Scaffold(
                backgroundColor: CustomColors.backgroundColor,
                appBar: AppBar(
                  // Here we take the value from the Daily object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: const Text('Mot aléatoire'),
                  backgroundColor: CustomColors.backgroundColor,
                ),
                body: Container(
                  margin: EdgeInsets.all(randomWord.length > 6 ? 10 : 30),
                  child: GameplayManager(
                    db: handler,
                    wordToFind: randomWord,
                    finished: false,
                    onFinish: onFinish,
                  ),
                ));
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return const CircularProgressIndicator();
          }
        },
      );
}
