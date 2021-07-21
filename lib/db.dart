import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/money_items.dart';


const moneyItemTableName = "money_item";

class DBProvider {
  static final DBProvider _singleton = DBProvider._internal();

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal();

  static Database? _db;

  Future<Database> get db async => _db ??= await _initDB();

  Future<Database> _initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await openDatabase(
        join(await getDatabasesPath(), 'cash_flow_database.db'),
        onCreate: _onCreate,
        version: 1);
    return database;
  }

  Future _onCreate(Database db, int version) async {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE $moneyItemTableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, money REAL, type INTEGER)',
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}
}

// Define a function that inserts dogs into the database
Future<void> insertShowItem(MoneyItem item) async {
  final db = await DBProvider().db;

  final id = await db.insert(
    moneyItemTableName,
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  item.id = id;
  print("insert model: " + id.toString());
}

Future<List<MoneyItem>> listShowItems() async {
  // Get a reference to the database.
  final db = await DBProvider().db;

  final List<Map<String, dynamic>> maps = await db.query(moneyItemTableName);

  return List.generate(maps.length, (i) {
    return MoneyItem.fromJson(maps[i]);
  });
}

Future<void> deleteShowItem(int id) async {
  final db = await DBProvider().db;

  await db.delete(
    moneyItemTableName,
    where: 'id = ?',
    whereArgs: [id],
  );
  print("delete item: " + id.toString());
}

Future<void> updateShowItem(MoneyItem item) async {
  final db = await DBProvider().db;

  await db.update(
    moneyItemTableName,
    item.toMap(),
    where: 'id = ?',
    whereArgs: [item.id],
  );
}
