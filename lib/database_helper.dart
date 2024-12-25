import 'dart:async';
import 'dart:io'; // Untuk file operations
import 'package:flutter/services.dart'; // Untuk akses ke assets
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Untuk mendapatkan direktori aplikasi

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Dapatkan path ke direktori aplikasi
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, 'user_database.db');

    // Periksa apakah database sudah ada
    if (!await File(dbPath).exists()) {
      // Jika belum ada, salin file database dari assets
      ByteData data = await rootBundle.load('assets/user_database.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
      print('Database berhasil disalin dari assets ke: $dbPath');
    } else {
      print('Database sudah ada di: $dbPath');
    }

    // Buka database
    final db = await openDatabase(dbPath);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    return db;
  }

  Future<int> insertUser(String username, String password) async {
    final db = await database;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
