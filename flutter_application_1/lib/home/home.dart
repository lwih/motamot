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
              if (snapshot.hasData) {
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
                    next: snapshot.data?.success != null
                        ? 'Disponible demain'
                        : 'Disponible maintenant',
                    success: snapshot.data?.success,
                    disabled: snapshot.data?.success == null ? false : true,
                    enableShare: snapshot.data?.success == null ? false : true,
                    onShare: () async {
                      await shareDailyResults(daily);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1, milliseconds: 200),
                        content: Text('Résumé copié dans le presse papier'),
                      ));
                    },
                  ),
                );
              } else {
                return Center(
                  child: CardButton(
                    onTap: () {},
                    title: 'Mot du jour',
                    description: 'Un jour, un mot, six tentatives',
                    next: null,
                    success: null,
                    disabled: true,
                    enableShare: false,
                    onShare: () {},
                  ),
                );
              }
            },
          ),
          FutureBuilder(
            future: handler.retrieveSprintChallenge(formattedToday()),
            builder: (context, AsyncSnapshot<Sprint> snapshot) {
              if (snapshot.hasData) {
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
                      next: 'Disponible tous les dimanches',
                      disabled: snapshot.data?.score == null ? false : true,
                      success: snapshot.data?.score == null ? null : true,
                      enableShare: snapshot.data?.score == null ? false : true,
                      onShare: () async {
                        await shareSprintResults(sprint.score ?? 0);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1, milliseconds: 200),
                          content: Text('Résumé copié dans le presse papier'),
                        ));
                      },
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CardButton(
                      onTap: () {},
                      title: 'Sprint',
                      description: "Jusqu'à 10 mots à trouver en 5 minutes",
                      next: 'Disponible tous les dimanches',
                      disabled: true,
                      success: null,
                      enableShare: false,
                      onShare: () {},
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
