import 'package:flutter/material.dart';

class Keystroke extends StatelessWidget {
  final String keyStore;
  final void Function()? onPressed;

  const Keystroke({required this.keyStore, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(keyStore),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        onPrimary: Colors.white,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        fixedSize: const Size(10, 10),
      ),
    );
  }
}
