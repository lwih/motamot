import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget wrapped(Widget widget) {
  return ResponsiveSizer(builder: (context, orientation, deviceType) {
    return MediaQuery(
        data: const MediaQueryData(), child: MaterialApp(home: widget));
  });
}
