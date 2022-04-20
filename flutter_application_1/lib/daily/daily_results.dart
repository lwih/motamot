import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';

class DailyResults extends StatelessWidget {
  final bool success;
  final String wordToFind;
  final void Function() shareResults;
  final void Function() goHome;

  const DailyResults(
      {required this.success,
      required this.wordToFind,
      required this.shareResults,
      required this.goHome,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomCenter,
      color: CustomColors.backgroundColor,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              success == true ? 'Félicitations' : 'Dommage...',
              style: const TextStyle(
                // fontSize: MediaQuery.of(context).size.height * 0.03,
                fontSize: 26,
                color: CustomColors.white,
                decoration: TextDecoration.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Le mot du jour était "${wordToFind.toUpperCase()}".',
                style: const TextStyle(
                  // fontSize: MediaQuery.of(context).size.height * 0.04,

                  fontSize: 16,
                  color: CustomColors.white,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const Text(
              'Reviens demain pour un nouveau mot.',
              style: TextStyle(
                // fontSize: MediaQuery.of(context).size.height * 0.04,

                fontSize: 16,
                color: CustomColors.white,
                overflow: TextOverflow.visible, decoration: TextDecoration.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: FloatingActionButton.extended(
                key: const Key('ShareButton'),
                label: const Text(
                  "Partager",
                  style: TextStyle(
                      // fontSize: 20,
                      // shadows: <Shadow>[
                      //   Shadow(
                      //     offset: Offset(1.0, 1.0),
                      //     blurRadius: 1.0,
                      //     color: Color.fromARGB(255, 90, 90, 90),
                      //   ),
                      // ],
                      ),
                ),
                backgroundColor: CustomColors.wrongPosition,
                icon: const Icon(
                  Icons.share,
                  size: 24.0,
                ),
                onPressed: shareResults,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FloatingActionButton.extended(
                key: const Key('HomeButton'),
                label: const Text(" Accueil "),
                backgroundColor: CustomColors.rightPosition,
                icon: const Icon(
                  Icons.home,
                  size: 24.0,
                ),
                onPressed: goHome,
              ),
            ),
          ],
        ),
      ),
    );
    // );
  }
}
