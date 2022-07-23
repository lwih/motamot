import 'dart:developer';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:motamot/ui/design.dart';

class CardButton extends StatelessWidget {
  final void Function() onTap;
  final void Function()? onShare;
  final bool enableShare;
  final bool? disabled;
  final String title;
  final String description;
  final bool? success;
  final String? next;

  const CardButton({
    required this.onTap,
    this.onShare,
    required this.enableShare,
    required this.title,
    required this.description,
    this.success,
    this.disabled,
    this.next,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: disabled == true
            ? CustomColors.disabledBackgroundColor
            : CustomColors.lighterBackgroundColor,
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 80.w,
            // height: 20.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      color: CustomColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 8.sp),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: CustomColors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  // trailing: success == null
                  //     ? null
                  //     : success == true
                  //         ? const Icon(
                  //             Icons.check_circle,
                  //             color: CustomColors.rightPosition,
                  //           )
                  //         : const Icon(
                  //             Icons.mood_bad_outlined,
                  //             color: CustomColors.wrongPosition,
                  //           ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        next != null ? '$next' : '',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    enableShare
                        ? IconButton(
                            icon: const Icon(Icons.share),
                            color: CustomColors.white,
                            iconSize: 35.sp,
                            onPressed: onShare,
                          )
                        : (disabled != null && !disabled!)
                            ? IconButton(
                                icon: const Icon(Icons.play_circle_outline),
                                color: CustomColors.rightPosition,
                                iconSize: 35.sp,
                                onPressed: onTap,
                              )
                            : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
