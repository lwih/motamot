import 'package:flutter/material.dart';
import 'package:flutter_application_1/gameplay/grid/cell.dart';
import 'package:flutter_application_1/gameplay/keyboard/keystoke.dart';
import 'package:flutter_application_1/ui/design.dart';

class DailyInstructions extends StatelessWidget {
  final void Function() onClose;

  const DailyInstructions({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomCenter,
      color: CustomColors.backgroundColor,
      padding: const EdgeInsets.all(50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'INSTRUCTIONS',
              style: TextStyle(
                fontSize: 26,
                color: CustomColors.white,
                decoration: TextDecoration.none,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                """
Trouvez le mot du jour en 6 tentatives.

Chaque tentative doit proposer un mot valide.

Après chaque tentative, les cellules changeront de couleur 
pour vous indiquer la proximité avec le mot à trouver

""",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.white,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Cell(
                        color: CustomColors.notInWord,
                        text: 'M',
                        size: 50,
                        fontSize: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "La lettre n'est pas présente dans le mot à trouver",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.white,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Cell(
                        color: CustomColors.wrongPosition,
                        text: 'M',
                        size: 50,
                        fontSize: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "La lettre existe dans le mot à trouver mais n'est pas à la bonne position",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.white,
                              overflow: TextOverflow.visible,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Cell(
                        color: CustomColors.rightPosition,
                        text: 'M',
                        size: 50,
                        fontSize: 20,
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'La lettre est à la bonne position',
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.white,
                              overflow: TextOverflow.visible,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: FloatingActionButton.extended(
                key: const Key('InstructionsCloseButton'),
                label: const Text("   Fermer   "),
                backgroundColor: CustomColors.rightPosition,
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
