import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


late Database db;
late List<Map<String, Object?>> menu;

Future<void> openDBConnection() async {
    var databaseFactory = databaseFactoryFfiWeb;

    String dbPath = join(Directory.current.path, 'lib', 'backend', 'webscraping', 'menu.db'); // No file path needed
    db = await databaseFactory.openDatabase(dbPath);
}

Future<List<Map<String, Object?>>> getFoodMenu() async {
  menu = await db.rawQuery('SELECT *;');
  print(menu);
  return menu;
}

  Future<void> loadJsonAsset() async { 
    
  var jsonData; 
  final String jsonString = await rootBundle.loadString('lib/menu.json'); 
  final data = jsonDecode(jsonString); 
  print(data);
  }

void main() async {
  
  await openDBConnection();
  await getFoodMenu();
}