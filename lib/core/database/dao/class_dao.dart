import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ClassDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertClass(Class classObj, String instructorName) async {
    final db = await _dbHelper.database;
    await db.insert('classes', {
      'id': classObj.id,
      'name': classObj.name,
      'join_code': classObj.joinCode,
      'instructor_id': classObj.instructorId,
      'instructor_name': instructorName,
      'status': classObj.status.name,
      'day': classObj.day,
      'start_time': '${classObj.startTime.hour}:${classObj.startTime.minute}',
      'end_time': '${classObj.endTime.hour}:${classObj.endTime.minute}',
      'enrolled_count': classObj.enrolledStudentIds.length,
      'created_at': DateTime.now().toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Class>> getClassesByInstructor(String instructorId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'classes',
      where: 'instructor_id = ?',
      whereArgs: [instructorId],
      orderBy: 'name ASC',
    );
    return result.map((map) => _mapToClass(map)).toList();
  }

  Future<List<Class>> getEnrolledClassesByStudent(String studentId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT c.* FROM classes c
      INNER JOIN enrolled_students e ON c.id = e.class_id
      WHERE e.student_id = ?
      ORDER BY c.name ASC
    ''', [studentId]);
    return result.map((map) => _mapToClass(map)).toList();
  }

  Future<Class?> getClassById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('classes', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return _mapToClass(result.first);
  }

  Future<Class?> getClassByJoinCode(String joinCode) async {
    final db = await _dbHelper.database;
    final result = await db.query('classes', where: 'join_code = ?', whereArgs: [joinCode]);
    if (result.isEmpty) return null;
    return _mapToClass(result.first);
  }

  Future<List<Class>> getAllClasses() async {
    final db = await _dbHelper.database;
    final result = await db.query('classes', orderBy: 'name ASC');
    return result.map((map) => _mapToClass(map)).toList();
  }

  Future<void> updateClass(Class classObj) async {
    final db = await _dbHelper.database;
    await db.update('classes', {
      'name': classObj.name,
      'status': classObj.status.name,
      'day': classObj.day,
      'start_time': '${classObj.startTime.hour}:${classObj.startTime.minute}',
      'end_time': '${classObj.endTime.hour}:${classObj.endTime.minute}',
      'last_updated': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [classObj.id]);
  }

  Future<void> updateEnrolledCount(String classId, int count) async {
    final db = await _dbHelper.database;
    await db.update('classes', {'enrolled_count': count}, where: 'id = ?', whereArgs: [classId]);
  }

  Future<void> deleteClass(String id) async {
    final db = await _dbHelper.database;
    await db.delete('classes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('classes');
  }

  Class _mapToClass(Map<String, dynamic> map) {
    final startTimeParts = (map['start_time'] as String).split(':');
    final endTimeParts = (map['end_time'] as String).split(':');
    
    return Class(
      id: map['id'],
      name: map['name'],
      joinCode: map['join_code'],
      instructorId: map['instructor_id'],
      enrolledStudentIds: [],
      status: ClassStatus.values.firstWhere((e) => e.name == map['status']),
      day: map['day'],
      startTime: TimeOfDay(hour: int.parse(startTimeParts[0]), minute: int.parse(startTimeParts[1])),
      endTime: TimeOfDay(hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1])),
    );
  }
}