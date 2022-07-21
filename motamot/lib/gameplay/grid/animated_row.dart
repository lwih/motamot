import 'package:flutter/material.dart';
import 'package:motamot/ui/design.dart';
import 'package:motamot/utils.dart';
import 'package:sizer/sizer.dart';

class AnimatedWordRow extends StatelessWidget {
  final double size;
  final AnimationController controller;
  final String wordToFind;
  final String word;
  final bool showHints;

  late final List<Animation> animations;

  AnimatedWordRow({
    Key? key,
    required this.controller,
    required this.size,
    required this.wordToFind,
    required this.word,
    required this.showHints,
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
        begin: CustomColors.lighterBackgroundColor,
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
      var styles = (i != 0 && showHints)
          ? TextStyle(
              color: CustomColors.hintText,
              fontWeight: FontWeight.bold,
              fontSize: wordToFind.length > 8 ? 12.sp : 13.sp,
            )
          : TextStyle(
              color: CustomColors.white,
              fontWeight: FontWeight.bold,
              fontSize: wordToFind.length > 8 ? 12.sp : 13.sp,
            );
      return Container(
        color: animations[i].value,
        width: size,
        height: size,
        child: Center(
          child: Text(
            word[i].toUpperCase(),
            style: styles,
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        word.length,
        (i) => Padding(
          padding: const EdgeInsets.all(1),
          child: AnimatedBuilder(
            animation: controller,
            builder: _buildLetterAnimation(i),
          ),
        ),
      ),
    );
  }
}

class LetterColors {
  static List<Color> listColors(String word, String wordToFind) {
    final statuses = getColorMapCorrection(wordToFind, word);
    return List.generate(wordToFind.length, (i) {
      if (statuses[i] == WordValidationStatus.goodPosition) {
        return CustomColors.rightPosition;
      } else if (statuses[i] == WordValidationStatus.wrongPosition) {
        return CustomColors.wrongPosition;
      } else if (statuses[i] == WordValidationStatus.notInWord ||
          statuses[i] == WordValidationStatus.ignored) {
        return CustomColors.backgroundColor;
      } else {
        return CustomColors.lighterBackgroundColor;
      }
    });
  }
}
