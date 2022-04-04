import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:flutter_application_1/keyboard/keystoke.dart';

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
    return Container(
      height: 200,
      color: CustomColors.backgroundColor,
      child: Column(
        children: [
          ...layout.map((List<String> row) {
            return Row(
                children: row.map((String key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Keystroke(
                      background: getKeyColor(key),
                      onPressed: () => chooseKey(key),
                      keyStroke: key),
                ),
              );
            }).toList());
          }).toList(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 100, // <-- Your width
                      height: 40, // <-- Your height
                      child: ElevatedButton(
                        onPressed: () => chooseKey('delete'),
                        child: const Text('effacer'),
                        style: ElevatedButton.styleFrom(
                          primary: CustomColors.notInWord,
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100, // <-- Your width
                      height: 40, // <-- Your height
                      child: ElevatedButton(
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
          ),
        ],
      ),
    );
  }
}
