import 'package:flutter/material.dart';
import 'package:flutter_application_1/daily/daily_share.dart';
import 'package:flutter_application_1/home/home_daily_card.dart';
import 'package:flutter_application_1/home/home_sprint_card.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';
import 'package:flutter_application_1/sprint/sprint_share.dart';
import 'package:flutter_application_1/ui/button/card_button.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:flutter_application_1/daily/daily.dart';
import 'package:flutter_application_1/sprint/sprint.dart';
import 'package:flutter_application_1/daily/daily_model.dart';
import 'package:flutter_application_1/ui/route/fade_route.dart';
import 'package:flutter_application_1/utils/date_utils.dart';

import '../storage/db_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHandler handler = DatabaseHandler('motus.db');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/logo.png'),
            ),
          ),
          HomeDailyCard(),
          HomeSprintCard(),
        ],
      ),
    );
  }
}
