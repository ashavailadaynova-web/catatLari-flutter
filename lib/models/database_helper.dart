import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'run_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('catatlari.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE runs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        distance REAL,
        duration TEXT,
        date TEXT,
        notes TEXT
      )
    ''');
  }

  Future<int> create(RunModel run) async {
    final db = await instance.database;
    return await db.insert('runs', run.toMap());
  }

  Future<List<RunModel>> readAllRuns() async {
    final db = await instance.database;
    final result = await db.query('runs', orderBy: 'id DESC');
    return result.map((json) => RunModel.fromMap(json)).toList();
  }

  Future<int> update(RunModel run) async {
    final db = await instance.database;
    return await db.update(
      'runs',
      run.toMap(),
      where: 'id = ?',
      whereArgs: [run.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('runs', where: 'id = ?', whereArgs: [id]);
  }
}
