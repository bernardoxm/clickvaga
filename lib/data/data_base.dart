import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }



Future<Database> _initDatabase() async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, 'clickvagas.db');

 
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE parkingSpot (
          id TEXT PRIMARY KEY,
          spotId TEXT,
          plate TEXT NOT NULL,
          entrydate INTEGER,
          exitdate INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE spot (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          isOccupied INTEGER
        )
      ''');
    },
    
  );


  
}}