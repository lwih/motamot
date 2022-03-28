import 'package:flutter/material.dart';
import 'package:flutter_application_1/design.dart';
import 'package:flutter_application_1/widgets/keystoke.dart';

@immutable
class Keyboard extends StatelessWidget {
  final ValueChanged<String> chooseKey;

  static final List<List<String>> layout = [
    ['a', 'z', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['q', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm'],
    [' ', ' ', 'w', 'x', 'c', 'v', 'b', 'n', ' ', ' ']
  ];

  const Keyboard({required this.chooseKey, Key? key}) : super(key: key);

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
                      onPressed: () => chooseKey(key), keyStroke: key),
                ),
              );
            }).toList());
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => chooseKey('delete'),
                    child: const Text('effacer'),
                    style: ElevatedButton.styleFrom(
                      primary: CustomColors.notInWord,
                      elevation: 3,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => chooseKey('enter'),
                    child: const Text('entrer'),
                    style: ElevatedButton.styleFrom(
                      primary: CustomColors.notInWord,
                      elevation: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
