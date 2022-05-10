import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Keystroke extends StatelessWidget {
  final String keyStroke;
  final Color background;
  final void Function()? onPressed;

  const Keystroke(
      {required this.keyStroke,
      required this.background,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: Key('Key${keyStroke.toUpperCase()}'),
      onPressed: onPressed,
      child: Center(
        child: Text(
          keyStroke.toUpperCase(),
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        enableFeedback: true,
        primary: background,
        padding: const EdgeInsets.all(1.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      ),
    );
  }
}
