import 'package:flutter/material.dart';
import 'package:motamot/home/home_daily_card.dart';
import 'package:motamot/home/home_sprint_card.dart';
import 'package:motamot/ui/design.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(30.sp),
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 50.sp,
              ),
            ),
          ),
          HomeDailyCard(),
          HomeSprintCard(),
        ],
      ),
    );
  }
}
