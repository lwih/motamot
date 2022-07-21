import 'package:flutter/material.dart';
import 'package:motamot/daily/daily.dart';
import 'package:motamot/daily/daily_model.dart';
import 'package:motamot/daily/daily_share.dart';
import 'package:motamot/storage/db_handler.dart';
import 'package:motamot/ui/button/card_button.dart';
import 'package:motamot/ui/route/fade_route.dart';
import 'package:motamot/utils/date_utils.dart';

class HomeDailyCard extends StatelessWidget {
  HomeDailyCard({Key? key}) : super(key: key);
  final DatabaseHandler handler = DatabaseHandler('motus.db');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
