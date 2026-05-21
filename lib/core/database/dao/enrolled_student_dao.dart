import 'package:attendance_app/core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class EnrolledStudentDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> enrollStudent({
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String classId,
    required String className,
  }) async {
    final db = await _dbHelper.database;
    await db.insert('enrolled_students', {
      'id': '${classId}_$studentId',
      'student_id': studentId,
      'student_name': studentName,
      'student_email': studentEmail,
      'class_id': classId,
      'class_name': className,
      'enrolled_at': DateTime.now().toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEnrolledStudentsByClass(String classId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'enrolled_students',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'student_name ASC',
    );
  }

  Future<bool> isStudentEnrolled(String studentId, String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'enrolled_students',
      where: 'student_id = ? AND class_id = ?',
      whereArgs: [studentId, classId],
    );
    return result.isNotEmpty;
  }

  Future<List<String>> getEnrolledClassIdsForStudent(String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'enrolled_students',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
    return result.map((row) => row['class_id'] as String).toList();
  }

  Future<void> removeStudent(String studentId, String classId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'enrolled_students',
      where: 'student_id = ? AND class_id = ?',
      whereArgs: [studentId, classId],
    );
  }

  Future<int> getEnrolledCount(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM enrolled_students WHERE class_id = ?',
      [classId],
    );
    return result.first['count'] as int;
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('enrolled_students');
  }
}