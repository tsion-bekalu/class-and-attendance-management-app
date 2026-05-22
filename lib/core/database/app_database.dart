import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'attendance_app.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE classes(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            days TEXT,
            startTime TEXT,
            endTime TEXT,
            students INTEGER,
            pending INTEGER,
            status TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE attendance_sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            time TEXT,
            attendanceCount TEXT,
            percentage TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE announcements(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            message TEXT,
            dateTime TEXT
          )
        ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS classes');

        await db.execute('''
      CREATE TABLE classes(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        days TEXT,
        startTime TEXT,
        endTime TEXT,
        students INTEGER,
        pending INTEGER,
        status TEXT
      )
    ''');

        if (oldVersion < 2) {
          await db.execute('''
        CREATE TABLE announcements(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          message TEXT,
          dateTime TEXT
        )
      ''');
        }
      },
    );
  }
}
