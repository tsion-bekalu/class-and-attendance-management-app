import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../domain/entities/class_entity.dart';

class ClassDatabase {
  Future<void> insertClass(ClassEntity classEntity) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('classes', {
      'id': classEntity.id,
      'name': classEntity.name,
      'description': classEntity.description,
      'days': classEntity.days.join(','),
      'startTime': classEntity.startTime,
      'endTime': classEntity.endTime,
      'students': classEntity.students,
      'pending': classEntity.pending,
      'status': classEntity.status,

      'instructorId': classEntity.instructorId,
      'instructorName': classEntity.instructorName,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ClassEntity?> getClassById(String id) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('classes', where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) {
      return null;
    }

    final e = result.first;

    return ClassEntity(
      id: e['id'] as String,

      name: e['name'] as String,

      description: e['description'] as String,

      days: (e['days'] as String).split(','),

      startTime: e['startTime'] as String,

      endTime: e['endTime'] as String,

      students: e['students'] as int,

      pending: e['pending'] as int,

      status: e['status'] as String,
      instructorId: e['instructorId'] as String,
      instructorName: e['instructorName'] as String,
    );
  }

  Future<List<ClassEntity>> getClasses(String instructorId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'classes',
      where: 'instructorId = ?',
      whereArgs: [instructorId],
    );

    return result.map((e) {
      return ClassEntity(
        id: e['id'] as String,
        name: e['name'] as String,
        description: e['description'] as String,
        days: (e['days'] as String).split(','),
        startTime: e['startTime'] as String,
        endTime: e['endTime'] as String,
        students: e['students'] as int,
        pending: e['pending'] as int,
        status: e['status'] as String,

        instructorId: e['instructorId'] as String,
        instructorName: e['instructorName'] as String,
      );
    }).toList();
  }

  Future<void> deleteClass(String id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete('classes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteInstructorClasses(String instructorId) async {
    final db = await DatabaseHelper.instance.database;

    final classes = await db.query(
      'classes',
      where: 'instructorId = ?',
      whereArgs: [instructorId],
    );

    for (final c in classes) {
      final classId = c['id'];

      await db.delete(
        'attendance_sessions',
        where: 'classId = ?',
        whereArgs: [classId],
      );

      await db.delete(
        'announcements',
        where: 'classId = ?',
        whereArgs: [classId],
      );
    }

    await db.delete(
      'classes',
      where: 'instructorId = ?',
      whereArgs: [instructorId],
    );
  }
}
