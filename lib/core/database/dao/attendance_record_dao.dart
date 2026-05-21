import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/attendance_record.dart';
import 'package:sqflite/sqflite.dart';


class AttendanceRecordDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertRecord(AttendanceRecord record) async {
    final db = await _dbHelper.database;
    await db.insert('attendance_records', {
      'id': record.id,
      'session_id': record.sessionId,
      'session_code': record.sessionCode,
      'class_id': record.classId,
      'class_name': record.className,
      'student_id': record.studentId,
      'student_name': record.studentName,
      'student_email': record.studentEmail,
      'timestamp': record.timestamp.toIso8601String(),
      'is_present': record.isPresent ? 1 : 0,
      'synced': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AttendanceRecord>> getRecordsBySession(String sessionId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => _mapToRecord(map)).toList();
  }

  Future<List<AttendanceRecord>> getRecordsByStudent(String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => _mapToRecord(map)).toList();
  }

  Future<List<AttendanceRecord>> getRecordsByClass(String classId, String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'class_id = ? AND student_id = ?',
      whereArgs: [classId, studentId],
      orderBy: 'timestamp DESC',
    );
    return result.map((map) => _mapToRecord(map)).toList();
  }

  Future<bool> hasStudentMarkedAttendance(String sessionId, String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'session_id = ? AND student_id = ?',
      whereArgs: [sessionId, studentId],
    );
    return result.isNotEmpty;
  }

  Future<int> getAttendanceCountForSession(String sessionId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'session_id = ? AND is_present = 1',
      whereArgs: [sessionId],
    );
    return result.length;
  }

  Future<double> getStudentAttendancePercentage(String studentId, String classId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT 
        COUNT(CASE WHEN is_present = 1 THEN 1 END) as present_count,
        COUNT(*) as total_count
      FROM attendance_records
      WHERE student_id = ? AND class_id = ?
    ''', [studentId, classId]);
    
    final presentCount = result.first['present_count'] as int;
    final totalCount = result.first['total_count'] as int;
    
    if (totalCount == 0) return 0.0;
    return (presentCount / totalCount) * 100;
  }

  Future<List<AttendanceRecord>> getUnsyncedRecords() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'attendance_records',
      where: 'synced = 0',
    );
    return result.map((map) => _mapToRecord(map)).toList();
  }

  Future<void> markAsSynced(String id) async {
    final db = await _dbHelper.database;
    await db.update('attendance_records', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRecord(String id) async {
    final db = await _dbHelper.database;
    await db.delete('attendance_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('attendance_records');
  }

  AttendanceRecord _mapToRecord(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      sessionId: map['session_id'],
      sessionCode: map['session_code'],
      classId: map['class_id'],
      className: map['class_name'],
      studentId: map['student_id'],
      studentName: map['student_name'],
      studentEmail: map['student_email'],
      timestamp: DateTime.parse(map['timestamp']),
      isPresent: map['is_present'] == 1,
    );
  }
}