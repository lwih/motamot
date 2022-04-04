import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/design.dart';

class CardButton extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String description;
  final bool? status;
  final String? next;

  const CardButton({
    required this.onTap,
    required this.title,
    required this.description,
    this.status,
    this.next,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: CustomColors.buttonColor,
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 300,
            height: 135,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    status == null
                        ? ''
                        : status == true
                            ? 'Status: gagné'
                            : 'Status: perdu',
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    next != null ? 'Prochain mot: $next' : '',
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
