import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/storage/db_handler.dart';
import 'package:flutter_application_1/home/home.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dbHandler = DatabaseHandler('motus.db');
  await dbHandler.initializeDB();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // DevicePreview(
  //   enabled: true,
  //   builder: (context) => const Mouitus(), // Wrap your app
  // );
  runApp(const Mouitus());
}

class Mouitus extends StatelessWidget {
  const Mouitus({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      title: 'Mouitus',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: CustomColors.backgroundColor,
          ),
      home: const Home(),
    );
  }
}
