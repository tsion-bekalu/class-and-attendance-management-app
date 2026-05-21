import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/join_request.dart';
import 'package:sqflite/sqflite.dart';

class JoinRequestDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertJoinRequest(JoinRequest request) async {
    final db = await _dbHelper.database;
    await db.insert('join_requests', {
      'id': request.id,
      'student_id': request.studentId,
      'student_name': request.studentName,
      'student_email': request.studentEmail,
      'class_id': request.classId,
      'class_name': request.className,
      'status': request.status.name,
      'submitted_at': request.submittedAt.toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<JoinRequest>> getRequestsByClass(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'join_requests',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'submitted_at DESC',
    );
    return result.map((map) => _mapToJoinRequest(map)).toList();
  }

  Future<List<JoinRequest>> getPendingRequestsByClass(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'join_requests',
      where: 'class_id = ? AND status = ?',
      whereArgs: [classId, 'pending'],
      orderBy: 'submitted_at DESC',
    );
    return result.map((map) => _mapToJoinRequest(map)).toList();
  }

  Future<List<JoinRequest>> getRequestsByStudent(String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'join_requests',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'submitted_at DESC',
    );
    return result.map((map) => _mapToJoinRequest(map)).toList();
  }

  Future<void> updateRequestStatus(String id, RequestStatus status) async {
    final db = await _dbHelper.database;
    await db.update('join_requests', {
      'status': status.name,
      'last_updated': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRequest(String id) async {
    final db = await _dbHelper.database;
    await db.delete('join_requests', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('join_requests');
  }

  JoinRequest _mapToJoinRequest(Map<String, dynamic> map) {
    return JoinRequest(
      id: map['id'],
      studentId: map['student_id'],
      studentName: map['student_name'],
      studentEmail: map['student_email'],
      classId: map['class_id'],
      className: map['class_name'],
      status: RequestStatus.values.firstWhere((e) => e.name == map['status']),
      submittedAt: DateTime.parse(map['submitted_at']),
    );
  }
}