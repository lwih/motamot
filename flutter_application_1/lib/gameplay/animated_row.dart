import 'package:flutter/material.dart';

class AnimatedWordRow extends StatelessWidget {
  final AnimationController controller;
  final String wordToFind;
  final String word;

  late final List<Animation> animations;

  AnimatedWordRow({
    Key? key,
    required this.controller,
    required this.wordToFind,
    required this.word,
  }) : super(key: key) {
    animations = _createAnimationSequence(controller);
  }

  List<Animation> _createAnimationSequence(AnimationController controller) {
    // percent of animation time per letter
    final timePerLetter = 1.0 / wordToFind.length;
    final letterColors = LetterColors.listColors(word, wordToFind);
    return List.generate(
      letterColors.length,
      (i) => ColorTween(
        begin: LetterColors.notInWord,
        end: letterColors[i],
      ).animate(
        CurvedAnimation(
          parent: controller,
          // start interval where previous one left off
          curve: Interval(
            timePerLetter * i,
            timePerLetter * i + timePerLetter,
            curve: Curves.ease,
          ),
        ),
      ),
    );
  }

  // create a function to render the nth animated letter
  _buildLetterAnimation(int i) {
    return (BuildContext context, Widget? child) {
      final screenWidth = MediaQuery.of(context).size.width;
      final size = (screenWidth / wordToFind.length) - 10;
      return Container(
        color: animations[i].value,
        width: size,
        height: size,
        child: Text(word[i]),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        word.length,
        (i) => AnimatedBuilder(
          animation: controller,
          builder: _buildLetterAnimation(i),
        ),
      ),
    );
  }
}

class LetterColors {
  static const notInWord = Colors.blue;
  static const rightPosition = Colors.green;
  static const wrongPosition = Colors.orange;

  static List<Color> listColors(String word, String wordToFind) {
    return List.generate(wordToFind.length, (i) {
      final letterToFind = wordToFind[i];
      final letterOfWord = word[i];
      if (letterToFind == letterOfWord) {
        return rightPosition;
      } else if (wordToFind.contains(letterOfWord)) {
        return wrongPosition;
      } else {
        return notInWord;
      }
    });
  }
}
