import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';

@immutable
class Cell extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final double fontSize;

  const Cell(
      {required this.color,
      required this.text,
      required this.size,
      required this.fontSize,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: size,
      height: size,
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
