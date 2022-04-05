import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';

import 'keystoke.dart';

@immutable
class Keyboard extends StatelessWidget {
  final List<String> rightPositionKeys;
  final List<String> wrongPositionKeys;
  final List<String> disableKeys;
  final ValueChanged<String> chooseKey;

  static final List<List<String>> layout = [
    ['a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm'],
    [' ', ' ', 'w', 'x', 'c', 'v', 'b', 'n', ' ', ' ']
  ];

  const Keyboard(
      {required this.chooseKey,
      required this.rightPositionKeys,
      required this.wrongPositionKeys,
      required this.disableKeys,
      Key? key})
      : super(key: key);

  Color getKeyColor(String key) {
    if (rightPositionKeys.contains(key)) {
      return CustomColors.rightPosition;
    } else if (wrongPositionKeys.contains(key)) {
      return CustomColors.wrongPosition;
    } else if (disableKeys.contains(key)) {
      return CustomColors.backgroundColor;
    } else {
      return CustomColors.notInWord;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          ...layout.map((List<String> row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((String key) {
                return Container(
                  padding: const EdgeInsets.all(1),
                  width: 35,
                  height: 50,
                  child: Keystroke(
                    background: getKeyColor(key),
                    onPressed: () => chooseKey(key),
                    keyStroke: key,
                  ),
                  // ),)

                  // Expanded(
                  //   // flex: -1,
                  //   // child: Padding(
                  //   //   padding: const EdgeInsets.all(1),
                  //   child: Keystroke(
                  //       background: getKeyColor(key),
                  //       onPressed: () => chooseKey(key),
                  //       keyStroke: key),
                  //   // ),
                );
              }).toList(),
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                  key: const Key('KeyDelete'),
                  onPressed: () => chooseKey('delete'),
                  child: const Text('effacer'),
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors.notInWord,
                    elevation: 3,
                  ),
                ),
              ),
              SizedBox(
                width: 100, // <-- Your width
                height: 40, // <-- Your height
                child: ElevatedButton(
                  key: const Key('KeyEnter'),
                  onPressed: () => chooseKey('enter'),
                  child: const Text('entrer'),
                  style: ElevatedButton.styleFrom(
                      primary: CustomColors.notInWord,
                      elevation: 3,
                      minimumSize: const Size.fromHeight(10.0)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
