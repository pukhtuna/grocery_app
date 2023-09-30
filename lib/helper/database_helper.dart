import 'dart:async';
import 'dart:io';

import 'package:grocery_app/models/grocery_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Get the directory where the database should be stored.
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}grocery_store.db';

    // Create the database if it doesn't exist.
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create the table for the grocery store items.
      await db.execute('''
        CREATE TABLE grocery_store_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price REAL NOT NULL,
          quantity INTEGER NOT NULL
        )
      ''');
    });

    return _database!;
  }

  Future<List<GroceryStoreItem>> getGroceryStoreItems() async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query('grocery_store_items');
    return results.map((result) => GroceryStoreItem.fromJson(result)).toList();
  }

  Future<void> addGroceryStoreItem(GroceryStoreItem groceryStoreItem) async {
    Database db = await database;
    await db.insert('grocery_store_items', groceryStoreItem.toJson());
  }

  Future<void> updateGroceryStoreItem(GroceryStoreItem groceryStoreItem) async {
    Database db = await database;
    await db.update('grocery_store_items', groceryStoreItem.toJson(),
        where: 'id = ?', whereArgs: [groceryStoreItem.id]);
  }

  Future<void> deleteGroceryStoreItem(int id) async {
    Database db = await database;
    await db.delete('grocery_store_items', where: 'id = ?', whereArgs: [id]);
  }
}
