import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:sizer/sizer.dart';
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
    ['delete', 'w', 'x', 'c', 'v', 'b', 'n', 'enter']
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
      return CustomColors.disabledBackgroundColor;
    } else {
      return CustomColors.lighterBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.backgroundColor,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              ...layout.map((List<String> row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((String key) {
                    if (key == 'delete' || key == 'enter') {
                      return Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Container(
                            color: CustomColors.lighterBackgroundColor,
                            width:
                                ((MediaQuery.of(context).size.width / 10) - 2) *
                                    2,
                            height: 40.sp - 2,
                            child: IconButton(
                              splashRadius: 22,
                              splashColor: Colors.white,
                              enableFeedback: true,
                              color: CustomColors.white,
                              key: Key(
                                  key == 'delete' ? 'KeyDelete' : 'KeyEnter'),
                              icon: Icon(
                                key == 'delete' ? Icons.backspace : Icons.check,
                                size: 14.sp,
                              ),
                              onPressed: () => chooseKey(key),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Flexible(
                        flex: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          width: (MediaQuery.of(context).size.width / 10) - 2,
                          height: 40.sp,
                          child: Keystroke(
                            background: getKeyColor(key),
                            onPressed: () => chooseKey(key),
                            keyStroke: key,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
