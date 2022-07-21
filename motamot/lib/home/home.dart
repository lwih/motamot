import 'package:flutter/material.dart';
import 'package:motamot/daily/daily_share.dart';
import 'package:motamot/home/home_daily_card.dart';
import 'package:motamot/home/home_sprint_card.dart';
import 'package:motamot/sprint/sprint_model.dart';
import 'package:motamot/sprint/sprint_share.dart';
import 'package:motamot/ui/button/card_button.dart';
import 'package:motamot/ui/design.dart';
import 'package:motamot/daily/daily.dart';
import 'package:motamot/sprint/sprint.dart';
import 'package:motamot/daily/daily_model.dart';
import 'package:motamot/ui/route/fade_route.dart';
import 'package:motamot/utils/date_utils.dart';

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
