import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hedieaty.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        phone TEXT UNIQUE,
        email TEXT UNIQUE,
        preferences TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        location TEXT,
        description TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES Users (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        event_id INTEGER,
        FOREIGN KEY (event_id) REFERENCES Events (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE Friends (
        user_id INTEGER,
        friend_id INTEGER,
        status TEXT,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES Users (id),
        FOREIGN KEY (friend_id) REFERENCES Users (id)
      );
    ''');
  }

  Future<void> dropAllTables() async {
    final db = await database;

    await db.execute('DROP TABLE IF EXISTS Users');
    await db.execute('DROP TABLE IF EXISTS Events');
    await db.execute('DROP TABLE IF EXISTS Gifts');

    print('All tables dropped successfully.');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
