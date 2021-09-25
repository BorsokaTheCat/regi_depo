import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase2.db";
  static final _databaseVersion = 1;

  static final table = 'sms2';

  static final columnId = '_id';
  static final columnNumber = 'number';
  static final columnMessage = 'message';
  static final columnFeedback = 'feedback';
  static final columnTime= 'time';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    print("here");
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNumber TEXT NOT NULL,
            $columnMessage TEXT NOT NULL,
            $columnTime TEXT, 
            $columnFeedback TEXT
          )
          ''');
  }



  Future deleteDB() async {
    await _database.delete("$table");
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }


  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

}
/*
class DatabaseManager {
  static final _dbName = "smsdb.db";
  // Use this class as a singleton
  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // Instantiate the database only when it's not been initialized yet.
    _database = await _initDatabase();
    return _database;
  }
  // Creates and opens the database.
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  // Creates the database structure
  Future _onCreate(
      Database db,
      int version,
      ) async {
    await db.execute('''
          CREATE TABLE smses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            number TEXT,
            message TEXT,
            feedback TEXT,
          )
          ''');
  }

  Future<List<Sms>> fetchAllTvSeries() async {
    Database database = _database;
    List<Map<String, dynamic>> maps = await database.query('TVSeries');
    if (maps.isNotEmpty) {
      return maps.map((map) => Sms.fromMap(map)).toList();
    }
    return null;
  }

  Future<int> addTVSeries(Sms sms) async {
    Database database = _database;
    return database.insert(
      'TVSeries',
      sms.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<int> updateTvSeries(Sms sms) async {
    Database database = _database;
    return database.update(
      'TVSeries',
      sms.toMap(),
      where: 'id = ?',
      whereArgs: [sms.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<int> deleteTvSeries(int id) async {
    Database database = _database;
    return database.delete(
      'TVSeries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


 */
/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sms/sms.dart';


import 'package:DepoSms/model/bean/Sms.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE smses(id INTEGER PRIMARY KEY AUTOINCREMENT, number TEXT NOT NULL, message TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertSmses(List<Sms> smses) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var user in smses){
      result = await db.insert('smses', user.toMap());
    }
    return result;
  }

  Future<List<Sms>> retrieveSmses() async {
    final Database db = await initializeDB();
    final List<Map<String, Object>> queryResult = await db.query('smses');
    return queryResult.map((e) => Sms.fromMap(e)).toList();


    
  }
}*/