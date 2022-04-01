import 'package:flutter/material.dart';
import 'package:flutter_application_1/design/card-button.dart';
import 'package:flutter_application_1/design/design.dart';
import 'package:flutter_application_1/design/fade_route.dart';
import 'package:flutter_application_1/routes/daily.dart';
import 'package:flutter_application_1/routes/random.dart';
import 'package:flutter_application_1/routes/sprint.dart';
import 'package:flutter_application_1/routes/stats.dart';
import 'package:flutter_application_1/storage/daily.dart';
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
  Widget build(BuildContext context) => FutureBuilder(
        future: handler.retrieveDailyChallenge(formattedToday()),
        builder: (context, AsyncSnapshot<Daily> snapshot) {
          if (snapshot.hasData) {
            final hasBeenPlayed = snapshot.data;
            // Build the widget with data.
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
                    //       Navigator.push(context,
                    //           FadeRoute(page: const RandomWordRoute()));
                    //     },
                    //     title: 'Mot Aléatoire',
                    //     description: 'mot random',
                    //   ),
                    // ),
                    Center(
                      child: CardButton(
                          onTap: () {
                            // hasBeenPlayed == true
                            //     ? () {}
                            //     : () {
                            //         Navigator.push(context,
                            // FadeRoute(page: const DailyWordRoute()));
                            //       },
                            Navigator.push(context,
                                FadeRoute(page: const DailyWordRoute()));
                          },
                          title: 'Mot du jour',
                          description:
                              'Garder son cerveau en forme en trouvant le mot du jour.',
                          next:
                              snapshot.data?.success != null ? 'demain' : null,
                          status: snapshot.data?.success),
                    ),
                    Center(
                      child: CardButton(
                          onTap: () {
                            // hasBeenPlayed == true
                            //     ? () {}
                            //     : () {
                            //         Navigator.push(context,
                            // FadeRoute(page: const DailyWordRoute()));
                            //       },
                            Navigator.push(
                                context, FadeRoute(page: const Sprint()));
                          },
                          title: 'Sprint du dimanche',
                          description:
                              'Tous les dimanches, 5 minutes pour tout donner.',
                          next: snapshot.data?.success != null
                              ? 'dimanche'
                              : null,
                          status: snapshot.data?.success),
                    ),
                  ],
                ));
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return Scaffold(
              backgroundColor: CustomColors.backgroundColor,
              body: Column(),
            );
          }
        },
      );
}
