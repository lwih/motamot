import 'package:flutter/material.dart';
import 'package:motamot/gameplay/grid/cell.dart';
import 'package:motamot/ui/design.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SprintInstructions extends StatelessWidget {
  final void Function() onClose;

  const SprintInstructions({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        leading: InkWell(
          onTap: onClose,
          child: const Icon(
            Icons.arrow_back,
            color: CustomColors.white,
          ),
        ),
        toolbarHeight: 6.h,
        title: Text(
          'Instructions',
          style: TextStyle(
            fontSize: 18.sp,
            color: CustomColors.white,
          ),
        ),
      ),
      body: Container(
        height: 100.h,
        color: CustomColors.backgroundColor,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    """
Vous avez jusqu'à 10 mots à trouver en 5 minutes.
Si vous trouvez un mot, votre score augmentera de 1 point, sinon il diminuera.

Vous avez 6 tentatives par mot.

Chaque proposition devra être un mot valide.

Après chaque tentative, les cellules changeront de couleur pour vous indiquer la proximité avec le mot à trouver

""",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: CustomColors.white,
                      overflow: TextOverflow.visible,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Cell(
                            color: CustomColors.notInWord,
                            text: 'M',
                            size: 30.sp,
                            fontSize: 16.sp,
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "La lettre n'est pas présente dans le mot à trouver",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: CustomColors.white,
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
                        children: [
                          Cell(
                            color: CustomColors.wrongPosition,
                            text: 'M',
                            size: 30.sp,
                            fontSize: 16.sp,
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "La lettre existe dans le mot à trouver mais n'est pas à la bonne position",
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                        children: [
                          Cell(
                            color: CustomColors.rightPosition,
                            text: 'M',
                            size: 30.sp,
                            fontSize: 16.sp,
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'La lettre est à la bonne position',
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                  padding: EdgeInsets.only(top: 50.sp),
                  child: SizedBox(
                    height: 30.sp,
                    width: 60.sp,
                    child: FloatingActionButton.extended(
                      key: const Key('InstructionsCloseButton'),
                      label: Text(
                        "Fermer",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      backgroundColor: CustomColors.rightPosition,
                      onPressed: onClose,
                      icon: Icon(
                        Icons.close,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
