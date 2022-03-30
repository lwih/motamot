import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<int> insertUser(List<Lemme> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  Future<String> retrieveDailyWorld() async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT lemme FROM lemme ORDER BY RANDOM() LIMIT 1;');
    return queryResult.map((e) => Lemme.fromMap(e)).toList().first.lemme;
  }

  Future<bool> wordExists(String word) async {
    final Database db = await openDB();
    final List<Map<String, Object?>> queryResult = await db.query('word',
        columns: ['word'], where: 'word = ?', whereArgs: [word]);
    return queryResult.isNotEmpty;
  }
}
