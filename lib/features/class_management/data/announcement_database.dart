import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../domain/entities/announcement.dart';

class AnnouncementDatabase {
  Future<void> insertAnnouncement(
    Announcement announcement,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    await db.insert(
      'announcements',
      {
        'id': DateTime.now()
            .millisecondsSinceEpoch
            .toString(),

        'classId': announcement.classId,
        'title': announcement.title,
        'message': announcement.message,
        'dateTime': announcement.dateTime,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  Future<List<Announcement>>
      getAnnouncements(
    String classId,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    final result = await db.query(
      'announcements',
      where: 'classId = ?',
      whereArgs: [classId],
      orderBy: 'dateTime DESC',
    );

    return result.map((e) {
      return Announcement(
        classId:
            e['classId'] as String,

        title:
            e['title'] as String,

        message:
            (e['message'] ??
                    e['description'])
                as String,

        dateTime:
            e['dateTime'] as String,
      );
    }).toList();
  }

  Future<void> deleteAnnouncement(
    String title,
  ) async {

    final db =
        await DatabaseHelper.instance.database;

    await db.delete(
      'announcements',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}