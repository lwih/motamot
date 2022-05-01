import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';

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
      // constraints: BoxConstraints.tight(const Size.fromWidth(100)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "C'est fini !",
              style: TextStyle(
                // fontSize: MediaQuery.of(context).size.height * 0.03,
                fontSize: 26,
                color: CustomColors.white,
                decoration: TextDecoration.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Votre score est de ${score.toString()}.',
                style: const TextStyle(
                  // fontSize: MediaQuery.of(context).size.height * 0.04,

                  fontSize: 16,
                  color: CustomColors.white,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: FloatingActionButton.extended(
                key: const Key('ShareButton'),
                label: const Text(
                  "Partager",
                  style: TextStyle(),
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
