import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';


class DBProvider {
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal(){
    initDB();
  }

  static late Database _db;

  Future<Database> get db async {
    return _db;
  }

  void initDB() async {
    _db = await _initDB();
  }

  Future<Database> _initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
        join(await getDatabasesPath(), 'doggie_database.db'),
        onCreate: _onCreate);
    return await database;
  }

  Future _onCreate(Database db, int version) async {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE show_item(id INTEGER PRIMARY KEY, name TEXT, money REAL, type INTEGER)',
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
