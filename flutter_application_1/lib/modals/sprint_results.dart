import 'package:flutter/material.dart';
import 'package:flutter_application_1/design/design.dart';

class SprintResults extends StatelessWidget {
  final int score;
  final void Function() shareResults;
  final void Function() goHome;

  const SprintResults(
      {required this.score,
      required this.shareResults,
      required this.goHome,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        //   width: MediaQuery.of(context).size.width * 0.8,
        //   child:
        Container(
      alignment: Alignment.bottomCenter,
      color: CustomColors.backgroundColor,
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints.tight(const Size.fromWidth(100)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Vous avez trouvé $score ${score > 1 ? 'mots' : 'mot'}.',
              style: const TextStyle(
                // fontSize: MediaQuery.of(context).size.height * 0.03,
                color: CustomColors.white,
                decoration: TextDecoration.none,
              ),
            ),
            // Text(
            //   'Le mot du jour est ${wordToFind.toUpperCase()}.',
            //   style: const TextStyle(
            //     // fontSize: MediaQuery.of(context).size.height * 0.04,
            //     color: CustomColors.white,
            //     overflow: TextOverflow.visible, decoration: TextDecoration.none,
            //   ),
            // ),
            ElevatedButton(
              child: const Text("Partager"),
              onPressed: shareResults,
            ),
            ElevatedButton(
              child: const Text("Retour à l'accueil"),
              onPressed: goHome,
            ),
          ],
        ),
      ),
    );
    // );
  }
}
