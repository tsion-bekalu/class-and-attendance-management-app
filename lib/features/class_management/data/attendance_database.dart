import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../domain/entities/session_record.dart';

class AttendanceDatabase {

  Future<void> insertSession(
    AttendanceSession session,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    await db.insert(
      'attendance_sessions',
      {
        'classId': session.classId,
        'date': session.date,
        'time': session.time,
        'attendanceCount':
            session.attendanceCount,
        'percentage':
            session.percentage,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<AttendanceSession>>
      getSessions(
    String classId,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    final result = await db.query(
      'attendance_sessions',
      where: 'classId = ?',
      whereArgs: [classId],
      orderBy: 'id DESC',
    );

    return result.map((e) {

      return AttendanceSession(
        id: e['id'] as int,

        classId:
            e['classId'] as String,

        date:
            e['date'] as String,

        time:
            e['time'] as String,

        attendanceCount:
            e['attendanceCount']
                as String,

        percentage:
            e['percentage']
                as String,
      );

    }).toList();
  }

  Future<void> deleteSession(
    int id,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    await db.delete(
      'attendance_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}