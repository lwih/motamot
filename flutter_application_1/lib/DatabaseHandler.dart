import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Daily {
  final String date;
  final String word;
  final bool? success;
  final int? attempts;

  Daily({
    required this.date,
    required this.word,
    required this.success,
    required this.attempts,
  });

  Daily.fromMap(Map<String, dynamic> res)
      : date = res['date'],
        word = res['word'],
        success = res['success'] == 1
            ? true
            : res['success'] == 0
                ? false
                : null,
        attempts = res['attempts'];

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'word': word,
      'success': success == true ? '1' : '0',
      'attempts': attempts.toString()
    };
  }
}

class Lemme {
  final String lemme;

  Lemme({
    required this.lemme,
  });

  Lemme.fromMap(Map<String, dynamic> res) : lemme = res["lemme"];

  Map<String, Object?> toMap() {
    return {
      'lemme': lemme,
    };
  }
}

class Word {
  final String word;

  Word({
    required this.word,
  });

  Word.fromMap(Map<String, dynamic> res) : word = res["word"];

  Map<String, Object?> toMap() {
    return {
      'word': word,
    };
  }
}

class DatabaseHandler {
  late String dbName;

  DatabaseHandler(this.dbName);

  initializeDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      log("Creating new db copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        log('error parent directory' + _.toString());
      }

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      log("Database already exists");
    }
    // open the database
    // var db = await openDatabase(path, readOnly: false, version: 1);
    // return db;
  }

  Future<Database> openDB() async {
    var db = await openDatabase(dbName, readOnly: false, version: 1);
    return db;
  }

  Future<String> retrieveDailyWord(String date) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'daily',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    await db.close();
    return queryResult.map((e) => Daily.fromMap(e)).toList().first.word;
  }

  Future<bool> dailyHasBeenPlayed(String date) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'daily',
      where: 'date = ?',
      whereArgs: [date],
    );
    await db.close();
    return queryResult.map((e) => Daily.fromMap(e)).toList().first.success !=
        null;
  }

  Future<int> updateDailyResult(
      {required String date,
      required bool success,
      required int attempts}) async {
    final Database db = await openDB();
    var update = await db.update(
      'daily',
      {
        'success': success == true ? '1' : '0',
        'attempts': attempts.toString(),
      },
      where: 'date = ?',
      whereArgs: [date],
    );
    await db.close();
    return update;
  }

  Future<String> retrieveRandomWord() async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT lemme FROM lemme ORDER BY RANDOM() LIMIT 1;');
    return queryResult.map((e) => Lemme.fromMap(e)).toList().first.lemme;
  }

  Future<bool> wordExists(String word) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'word',
      columns: ['word'],
      where: 'word = ?',
      whereArgs: [word],
    );
    await db.close();
    return queryResult.isNotEmpty;
  }
}
