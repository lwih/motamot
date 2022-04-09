import 'package:flutter/material.dart';
import 'package:flutter_application_1/daily/daily_share.dart';
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
            // Center(
            //   child: CardButton(
            //     onTap: () {
            //       Navigator.push(
            //           context, FadeRoute(page: const RandomWordRoute()));
            //     },
            //     title: 'Mot Aléatoire',
            //     description: 'mot random',
            //   ),
            // ),
            FutureBuilder(
              future: handler.retrieveDailyChallenge(formattedToday()),
              builder: (context, AsyncSnapshot<Daily> snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    backgroundColor: CustomColors.backgroundColor,
                    body: Column(
                      children: const [
                        Text('error'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  Daily daily = snapshot.data!;
                  return Center(
                    child: CardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          FadeRoute(
                            page: DailyWordRoute(
                              daily: daily,
                            ),
                          ),
                        );
                      },
                      title: 'Mot du jour',
                      description: 'Un jour, un mot, six tentatives',
                      next: snapshot.data?.success != null ? 'demain' : null,
                      success: snapshot.data?.success,
                      onShare: () async {
                        await shareDailyResults(daily);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Résumé copié dans le presse papier'),
                        ));
                      },
                    ),
                  );
                } else {
                  return Column(
                    children: const [
                      Text('loading'),
                    ],
                  );
                }
              },
            ),
            FutureBuilder(
              future: handler.retrieveSprintChallenge(formattedToday()),
              builder: (context, AsyncSnapshot<Sprint> snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    backgroundColor: CustomColors.backgroundColor,
                    body: Column(
                      children: const [
                        Text('error'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  Sprint sprint = snapshot.data!;
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CardButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: SprintWordRoute(
                                sprint: sprint,
                              ),
                            ),
                          );
                        },
                        title: 'Sprint',
                        description: "10 mots en 5 minutes, c'est pas évident",
                        next: snapshot.data?.score != null ? 'dimanche' : null,
                        success: snapshot.data?.score == null ? null : true,
                        onShare: () async {
                          await shareSprintResults(sprint);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Résumé copié dans le presse papier'),
                          ));
                        },
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: const [
                      Text('loading'),
                    ],
                  );
                }
              },
            ),
          ],
        ));
  }
}
