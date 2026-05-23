import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../domain/entities/class_entity.dart';

class ClassDatabase {
  Future<void> insertClass(ClassEntity classEntity) async {
    final db = await AppDatabase.database;

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
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ClassEntity?> getClassById(String id) async {
    final db = await AppDatabase.database;

    final result = await db.query('classes', where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) return null;

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
    );
  }

  Future<List<ClassEntity>> getClasses() async {
    final db = await AppDatabase.database;

    final result = await db.query('classes');

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
      );
    }).toList();
  }

  Future<void> deleteClass(String id) async {
    final db = await AppDatabase.database;

    await db.delete('classes', where: 'id = ?', whereArgs: [id]);
  }
}
