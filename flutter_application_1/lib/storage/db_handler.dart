import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/daily/daily_model.dart';
import 'package:flutter_application_1/storage/lemme.dart';
import 'package:flutter_application_1/sprint/sprint_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@GenerateMocks([DatabaseHandler])
class DatabaseHandler {
  late String dbName;

  DatabaseHandler(this.dbName);

  dynamic db;

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
    var database = await openDatabase(dbName, readOnly: false, version: 1);
    db = database;
    return db;
  }

  Future<Database> getDB() async {
    if (db == null) {
      return await openDB();
    } else {
      return db;
    }
  }

  Future close() async {
    return db.close();
  }

  Future<Daily> retrieveDailyChallenge(String date) async {
    final Database db = await getDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'daily',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    // await db.close();
    return queryResult.map((e) => Daily.fromMap(e)).toList().first;
  }

  // Future<bool> dailyHasBeenPlayed(String date) async {
  //   final Database db = await openDB();
  //   final List<Map<String, Object?>> queryResult = await db.query(
  //     'daily',
  //     where: 'date = ?',
  //     whereArgs: [date],
  //   );
  // await db.close();
  //   return queryResult.map((e) => Daily.fromMap(e)).toList().first.success !=
  //       null;
  // }

  Future<int> updateDailyResult({
    required String date,
    required bool success,
  }) async {
    final Database db = await getDB();
    var update = await db.update(
      'daily',
      {
        'success': success == true ? '1' : '0',
      },
      where: 'date = ?',
      whereArgs: [date],
    );
    // await db.close();
    return update;
  }

  Future<int> updateDailyWordsInProgress(
      {required String date, required List<String> words}) async {
    final Database db = await getDB();
    var update = await db.update(
      'daily',
      {
        'words': words.join(','),
      },
      where: 'date = ?',
      whereArgs: [date],
    );
    // await db.close();
    return update;
  }

  Future<String> retrieveRandomWord() async {
    final Database db = await getDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT lemme FROM lemme ORDER BY RANDOM() LIMIT 1;');
    return queryResult.map((e) => Lemme.fromMap(e)).toList().first.lemme;
  }

  Future<bool> wordExists(String word) async {
    final Database db = await getDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'word',
      columns: ['word'],
      where: 'word = ?',
      whereArgs: [word],
    );
    // await db.close();
    return queryResult.isNotEmpty;
  }

  Future<Sprint?> retrieveSprintChallenge(String date) async {
    final Database db = await getDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'sprint',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    // await db.close();
    final results = queryResult.map((e) => Sprint.fromMap(e)).toList();
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateSprintResult({
    required String table,
    required int id,
    required int score,
    required int timeLeftInSeconds,
  }) async {
    final Database db = await getDB();
    var update = await db.update(
      table,
      {
        'score': score,
        'timeLeftInSeconds': timeLeftInSeconds,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    // await db.close();
    return update;
  }

  Future<int> updateSprintWordsInProgress(
      {required String table,
      required int id,
      required List<String> words,
      required int timeLeftInSeconds}) async {
    final Database db = await getDB();
    var update = await db.update(
      table,
      {
        'wordsInProgress': words.join(','),
        'timeLeftInSeconds': timeLeftInSeconds
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    // await db.close();
    return update;
  }

  Future<List<Sprint>> retrieveFreeSprints() async {
    final Database db = await getDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'sprint_free',
      where: 'timeLeftInSeconds != 0 OR timeLeftInSeconds IS NULL',
    );
    // await db.close();
    final results = queryResult.map((e) => Sprint.fromMap(e)).toList();
    return results;
  }
}

class GenerateMocks {
  const GenerateMocks(List<Type> list);
}
