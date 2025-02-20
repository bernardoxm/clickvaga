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

    await deleteDatabase(path);
// alterar nome da tabela para ser mais coerente com o Projeto
// data nao deve ser armazenado como texto por gentileza usar o tipo de dado correto
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE parkingSpot (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plate TEXT NOT NULL,
            isOccupied INTEGER NOT NULL,
            entrydate DATA,
            exitdate TEXT
          )
          '''
        );
      },
    );
  }
}
