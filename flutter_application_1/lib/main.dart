import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/DatabaseHandler.dart';
import 'package:flutter_application_1/design.dart';
import 'package:flutter_application_1/pages/daily.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

dbStuff() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "motus.db");

  // Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // Should happen only the first time you launch your application
    log("Creating new copy from asset");

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {
      log('error parent directory' + _.toString());
    }

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "motus.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    log("Opening existing database");
  }
  // open the database
  var db = await openDatabase(path, readOnly: false, version: 1);
  log(db.path);
  var bite = await db.rawQuery(
      "SELECT name FROM sqlite_schema WHERE type ='table' AND name NOT LIKE 'sqlite_%';");
  log('ok');
  final List<Map<String, dynamic>> maps = await db.rawQuery(
    "SELECT * FROM lemme ORDER BY RANDOM() LIMIT 1",
  );
  log('ok');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Mouitus());
  var dbHandler = DatabaseHandler('motus.db');
  await dbHandler.initializeDB();
}

class Mouitus extends StatelessWidget {
  const Mouitus({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const DailyPage(),
    );
  }
}
