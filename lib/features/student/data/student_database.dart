// features/student/data/student_database.dart
import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';

class StudentDatabase {
  Future<Database> get database async {
  return await DatabaseHelper.instance.database;
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
