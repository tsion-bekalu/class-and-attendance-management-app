// features/student/data/student_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._init();
  static Database? _db;

  StudentDatabase._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('student.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        courseCode TEXT NOT NULL,
        instructorId TEXT NOT NULL,
        instructorName TEXT NOT NULL,
        schedule TEXT NOT NULL,
        roomNumber TEXT NOT NULL,
        attendancePercentage REAL NOT NULL DEFAULT 0,
        presentSessions INTEGER NOT NULL DEFAULT 0,
        totalSessions INTEGER NOT NULL DEFAULT 0,
        cachedAt INTEGER NOT NULL
      )
    ''');

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

    await db.execute('''
      CREATE TABLE announcements (
        id TEXT PRIMARY KEY,
        classId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        cachedAt INTEGER NOT NULL
      )
    ''');
  }

  // ── Classes ──────────────────────────────────────────────────────────────

  Future<void> upsertClasses(List<Map<String, dynamic>> classes) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final c in classes) {
      batch.insert(
        'classes',
        {...c, 'cachedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedClasses() async {
    final db = await database;
    return db.query('classes', orderBy: 'name ASC');
  }

  Future<Map<String, dynamic>?> getCachedClass(String classId) async {
    final db = await database;
    final rows = await db.query('classes', where: 'id = ?', whereArgs: [classId]);
    return rows.isEmpty ? null : rows.first;
  }

  // ── Attendance History ────────────────────────────────────────────────────

  Future<void> upsertAttendanceHistory(
      String classId, List<Map<String, dynamic>> entries) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final e in entries) {
      batch.insert(
        'attendance_history',
        {...e, 'classId': classId, 'cachedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedAttendanceHistory(
      String classId) async {
    final db = await database;
    return db.query(
      'attendance_history',
      where: 'classId = ?',
      whereArgs: [classId],
      orderBy: 'date DESC',
    );
  }

  // ── Notifications ─────────────────────────────────────────────────────────

  Future<void> upsertNotifications(List<Map<String, dynamic>> notifications) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final n in notifications) {
      batch.insert(
        'notifications',
        {...n, 'cachedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedNotifications() async {
    final db = await database;
    return db.query('notifications', orderBy: 'cachedAt DESC');
  }

  Future<void> markNotificationRead(String id) async {
    final db = await database;
    await db.update('notifications', {'isUnread': 0},
        where: 'id = ?', whereArgs: [id]);
  }

  // ── Timetable ─────────────────────────────────────────────────────────────

  Future<void> upsertTimetable(List<Map<String, dynamic>> entries) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final e in entries) {
      batch.insert(
        'timetable',
        {...e, 'cachedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedTimetable(String day) async {
    final db = await database;
    return db.query('timetable',
        where: 'day = ?', whereArgs: [day], orderBy: 'time ASC');
  }

  // ── Student Profile ───────────────────────────────────────────────────────

  Future<void> upsertStudentProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert(
      'student_profile',
      {...profile, 'cachedAt': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedStudentProfile(String id) async {
    final db = await database;
    final rows =
        await db.query('student_profile', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  // ── Announcements ─────────────────────────────────────────────────────────

  Future<void> upsertAnnouncements(
      String classId, List<Map<String, dynamic>> items) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final a in items) {
      batch.insert(
        'announcements',
        {...a, 'classId': classId, 'cachedAt': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedAnnouncements(
      String classId) async {
    final db = await database;
    return db.query(
      'announcements',
      where: 'classId = ?',
      whereArgs: [classId],
      orderBy: 'dateTime DESC',
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns true if the cache entry is still fresh (within [maxAgeMinutes]).
  bool isFresh(int cachedAt, {int maxAgeMinutes = 10}) {
    final age = DateTime.now().millisecondsSinceEpoch - cachedAt;
    return age < maxAgeMinutes * 60 * 1000;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
