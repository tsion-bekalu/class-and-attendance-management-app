import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../domain/entities/announcement.dart';

class AnnouncementDatabase {
  Future<void> insertAnnouncement(
    Announcement announcement,
  ) async {
    final db = await AppDatabase.database;

    await db.insert(
      'announcements',
      {
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
    final db = await AppDatabase.database;

    final result = await db.query(
      'announcements',
      where: 'classId = ?',
      whereArgs: [classId],
      orderBy: 'id DESC',
    );


    return result.map((e) {
      return Announcement(
        classId:
            e['classId'] as String,
        title:
            e['title'] as String,
        message:
            e['message'] as String,
        dateTime:
            e['dateTime'] as String,
      );
    }).toList();
  }

  Future<void> deleteAnnouncement(
    String title,
  ) async {
    final db = await AppDatabase.database;

    await db.delete(
      'announcements',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}