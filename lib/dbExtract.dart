import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

late Database db;
late List<Map<String, Object?>> menu;

Future<void> openDBConnection() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  String dbPath = join(Directory.current.path, 'lib', 'backend', 'webscraping', 'menu.db');
  print("Database at $dbPath");

  db = await openDatabase(dbPath, version: 1);
}

Future<void> getFoodMenu() async {
  menu = await db.rawQuery('SELECT * FROM MENU LIMIT 5;');
}




