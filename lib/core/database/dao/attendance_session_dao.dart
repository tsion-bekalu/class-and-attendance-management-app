import 'package:sqflite/sqflite.dart';
import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/attendance_session.dart';

class AttendanceSessionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertSession(AttendanceSession session) async {
    final db = await _dbHelper.database;
    await db.insert('attendance_sessions', {
      'id': session.id,
      'class_id': session.classId,
      'class_name': session.className,
      'start_time': session.startTime.toIso8601String(),
      'end_time': session.endTime.toIso8601String(),
      'session_code': session.sessionCode,
      'qr_code_data': session.qrCodeData,
      'is_active': session.isActive ? 1 : 0,
      'total_students': session.totalStudents,
      'attended_count': session.attendedCount,
      'created_at': DateTime.now().toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AttendanceSession>> getSessionsByClass(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_sessions',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'start_time DESC',
    );
    return result.map((map) => _mapToSession(map)).toList();
  }

  Future<AttendanceSession?> getActiveSessionByClass(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_sessions',
      where: 'class_id = ? AND is_active = 1',
      whereArgs: [classId],
    );
    if (result.isEmpty) return null;
    return _mapToSession(result.first);
  }

  Future<AttendanceSession?> getSessionById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('attendance_sessions', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return _mapToSession(result.first);
  }

  Future<AttendanceSession?> getSessionByCode(String sessionCode) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_sessions',
      where: 'session_code = ? AND is_active = 1',
      whereArgs: [sessionCode],
    );
    if (result.isEmpty) return null;
    return _mapToSession(result.first);
  }

  Future<void> updateSession(AttendanceSession session) async {
    final db = await _dbHelper.database;
    await db.update('attendance_sessions', {
      'is_active': session.isActive ? 1 : 0,
      'attended_count': session.attendedCount,
      'last_updated': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [session.id]);
  }

  Future<void> endSession(String id) async {
    final db = await _dbHelper.database;
    await db.update('attendance_sessions', {
      'is_active': 0,
      'last_updated': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSession(String id) async {
    final db = await _dbHelper.database;
    await db.delete('attendance_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('attendance_sessions');
  }

  AttendanceSession _mapToSession(Map<String, dynamic> map) {
    return AttendanceSession(
      id: map['id'],
      classId: map['class_id'],
      className: map['class_name'],
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      sessionCode: map['session_code'],
      qrCodeData: map['qr_code_data'],
      isActive: map['is_active'] == 1,
      totalStudents: map['total_students'],
      attendedCount: map['attended_count'],
    );
  }
}