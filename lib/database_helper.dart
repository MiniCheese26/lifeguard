// Credit: https://stackoverflow.com/a/54223930

import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static final _databaseName = "saved_addresses_database.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE saved_addresses (
            id INTEGER PRIMARY KEY,
            address TEXT NOT NULL,
            pool INTEGER NOT NULL,
            is_default INTEGER NOT NULL UNIQUE
          )
          ''');
    await db.execute('''
    CREATE TABLE saved_workers (
    id INTEGER PRIMARY KEY,
    address_id INTEGER,
    worker_name TEXT NOT NULL,
    FOREIGN KEY(address_id) REFERENCES saved_addresses(id)
    )
    ''');
  }
}
