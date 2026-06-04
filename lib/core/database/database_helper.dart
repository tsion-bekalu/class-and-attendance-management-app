import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance =
      DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {

    String path;

    if (kIsWeb) {
      path = 'attendance_app.db';
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'attendance_app.db');
    }

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  if (oldVersion < 3) {
    await db.execute(
      'ALTER TABLE attendance_sessions ADD COLUMN sessionCode TEXT',
    );

    await db.execute(
      'ALTER TABLE attendance_sessions ADD COLUMN isActive INTEGER DEFAULT 1',
    );
  }
}

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    // ─────────────────────────────────────────────────────────────
    // AUTH TABLES
    // ─────────────────────────────────────────────────────────────

    await db.execute('''
      CREATE TABLE auth_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        accessToken TEXT NOT NULL,
        refreshToken TEXT,
        tokenExpiresAt INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE auth_tokens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        accessToken TEXT NOT NULL,
        refreshToken TEXT,
        expiresAt INTEGER,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL UNIQUE,
        selectedRole TEXT,
        rememberMe INTEGER DEFAULT 0,
        theme TEXT DEFAULT 'light',
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    // ─────────────────────────────────────────────────────────────
    // CLASS MANAGEMENT TABLES
    // ─────────────────────────────────────────────────────────────

    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        days TEXT,
        startTime TEXT,
        endTime TEXT,
        students INTEGER,
        pending INTEGER,
        status TEXT,

        courseCode TEXT,
        instructorId TEXT,
        instructorName TEXT,
        schedule TEXT,
        roomNumber TEXT,
        attendancePercentage REAL DEFAULT 0,
        presentSessions INTEGER DEFAULT 0,
        totalSessions INTEGER DEFAULT 0,

        cachedAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classId TEXT,
        sessionCode TEXT,
        date TEXT,
        time TEXT,
        attendanceCount TEXT,
        percentage TEXT
        isActive INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE announcements (
        id TEXT PRIMARY KEY,
        classId TEXT,
        title TEXT,
        message TEXT,
        description TEXT,
        dateTime TEXT,
        cachedAt INTEGER
      )
    ''');

    // ─────────────────────────────────────────────────────────────
    // STUDENT FEATURE TABLES
    // ─────────────────────────────────────────────────────────────

    await db.execute('''
      CREATE TABLE attendance_history (
        id TEXT PRIMARY KEY,
        classId TEXT NOT NULL,
        topic TEXT NOT NULL,
        date TEXT NOT NULL,
        isPresent INTEGER NOT NULL DEFAULT 0,
        sessionCode TEXT,
        cachedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        courseCode TEXT NOT NULL,
        courseName TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        timeAgo TEXT NOT NULL,
        type TEXT NOT NULL,
        isUnread INTEGER NOT NULL DEFAULT 1,
        cachedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE timetable (
        id TEXT PRIMARY KEY,
        classId TEXT NOT NULL,
        day TEXT NOT NULL,
        title TEXT NOT NULL,
        courseCode TEXT NOT NULL,
        time TEXT NOT NULL,
        location TEXT NOT NULL,
        duration TEXT NOT NULL,
        accentColor INTEGER NOT NULL,
        cachedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE student_profile (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        studentId TEXT NOT NULL,
        overallAttendance REAL NOT NULL DEFAULT 0,
        presentSessions INTEGER NOT NULL DEFAULT 0,
        absentSessions INTEGER NOT NULL DEFAULT 0,
        cachedAt INTEGER NOT NULL
      )
    ''');
  }

  // ─────────────────────────────────────────────────────────────
  // GENERIC DATABASE METHODS
  // ─────────────────────────────────────────────────────────────

  Future<int> insert(
    String table,
    Map<String, dynamic> values,
  ) async {

    final db = await database;

    return await db.insert(
      table,
      values,
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {

    final db = await database;

    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {

    final db = await database;

    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {

    final db = await database;

    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<void> clearTable(
    String table,
  ) async {

    final db = await database;

    await db.delete(table);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}


