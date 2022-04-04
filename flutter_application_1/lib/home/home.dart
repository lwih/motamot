import 'package:flutter/material.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';
import 'package:flutter_application_1/ui/button/card-button.dart';
import 'package:flutter_application_1/ui/design.dart';
import 'package:flutter_application_1/daily/daily.dart';
import 'package:flutter_application_1/sprint/sprint.dart';
import 'package:flutter_application_1/daily/daily_model.dart';
import 'package:flutter_application_1/ui/route/fade_route.dart';
import 'package:flutter_application_1/utils/date_utils.dart';

import '../storage/db-handler.dart';

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
                        // hasBeenPlayed == true
                        //     ? () {}
                        //     : () {
                        //         Navigator.push(context,
                        // FadeRoute(page: const DailyWordRoute()));
                        //       },
                        Navigator.push(
                            context,
                            FadeRoute(
                                page: DailyWordRoute(
                              daily: daily,
                            )));
                      },
                      title: 'Mot du jour',
                      description:
                          'Garder son cerveau en forme en trouvant le mot du jour.',
                      next: snapshot.data?.success != null ? 'demain' : null,
                      status: snapshot.data?.success,
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
                    child: CardButton(
                        onTap: () {
                          // hasBeenPlayed == true
                          //     ? () {}
                          //     : () {
                          //         Navigator.push(context,
                          // FadeRoute(page: const DailyWordRoute()));
                          //       },
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: SprintWordRoute(
                                sprint: sprint,
                              ),
                            ),
                          );
                        },
                        title: 'Sprint du dimanche',
                        description:
                            'Tous les dimanches, 5 minutes pour tout donner.',
                        next: snapshot.data?.score != null ? 'dimanche' : null,
                        status: snapshot.data?.score != null),
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
