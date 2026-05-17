import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'run_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Memperbaiki pemanggilan internal agar selalu konsisten menggunakan getter
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await instance._initDB('catatlari.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // KITA NAIKKAN VERSION KE 2 KARENA ADA PERUBAHAN STRUKTUR TABEL (MIGRATION)
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    // 1. BUAT TABEL USERS UNTUK MENAMPUNG AKUN REGISTRASI
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // 2. BUAT TABEL RUNS DENGAN MENAMBAHKAN KOLOM user_email SEBAGAI PENGIKAT DATA
    await db.execute('''
      CREATE TABLE runs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT,
        distance REAL,
        duration TEXT,
        date TEXT,
        notes TEXT
      )
    ''');
  }

  // Handle jika user sudah terlanjur menginstal versi database lama di HP/Emulator
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS runs');
      await _createDB(db, newVersion);
    }
  }

  // ==========================================
  //            LOGIC UNTUK AUTH / USER
  // ==========================================

  // Fungsi untuk menyimpan user baru saat Registrasi
  static Future<int> registerUser(String name, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // Fungsi untuk memvalidasi login (Dipanggil di AuthViewModel)
  static Future<Map<String, dynamic>?> checkLogin(String email, String password) async {
    final db = await database;
    
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // ==========================================
  //         LOGIC UNTUK CATATAN LARI (RUNS)
  // ==========================================

  // Menyimpan riwayat lari spesifik milik user yang sedang aktif
  Future<int> create(RunModel run, String? userEmail) async {
    final db = await database;
    
    // Konversi objek model ke Map dan sisipkan email user aktif
    final runMap = run.toMap();
    runMap['user_email'] = userEmail ?? '';

    return await db.insert('runs', runMap);
  }

  // Membaca semua data lari HANYA milik user yang sedang login aktif
  Future<List<RunModel>> readAllRuns(String? userEmail) async {
    final db = await database;
    
    final result = await db.query(
      'runs', 
      where: 'user_email = ?',
      whereArgs: [userEmail ?? ''],
      orderBy: 'id DESC',
    );
    
    return result.map((json) => RunModel.fromMap(json)).toList();
  }

  Future<int> update(RunModel run) async {
    final db = await database;
    return await db.update(
      'runs',
      run.toMap(),
      where: 'id = ?',
      whereArgs: [run.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('runs', where: 'id = ?', whereArgs: [id]);
  }
}