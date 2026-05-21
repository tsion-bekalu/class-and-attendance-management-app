import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/announcement.dart';
import 'package:sqflite/sqflite.dart';

class AnnouncementDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertAnnouncement(Announcement announcement) async {
    final db = await _dbHelper.database;
    await db.insert('announcements', {
      'id': announcement.id,
      'class_id': announcement.classId,
      'class_name': announcement.className,
      'title': announcement.title,
      'content': announcement.content,
      'created_at': announcement.createdAt.toIso8601String(),
      'updated_at': announcement.updatedAt.toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Announcement>> getAnnouncementsByClass(String classId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'announcements',
      where: 'class_id = ?',
      whereArgs: [classId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => _mapToAnnouncement(map)).toList();
  }

  Future<List<Announcement>> getAnnouncementsForStudent(List<String> classIds) async {
    if (classIds.isEmpty) return [];
    
    final db = await _dbHelper.database;
    final placeholders = classIds.map((_) => '?').join(',');
    final result = await db.query(
      'announcements',
      where: 'class_id IN ($placeholders)',
      whereArgs: classIds,
      orderBy: 'created_at DESC',
    );
    return result.map((map) => _mapToAnnouncement(map)).toList();
  }

  Future<Announcement?> getAnnouncementById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('announcements', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return _mapToAnnouncement(result.first);
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    final db = await _dbHelper.database;
    await db.update('announcements', {
      'title': announcement.title,
      'content': announcement.content,
      'updated_at': announcement.updatedAt.toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [announcement.id]);
  }

  Future<void> deleteAnnouncement(String id) async {
    final db = await _dbHelper.database;
    await db.delete('announcements', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('announcements');
  }

  Announcement _mapToAnnouncement(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'],
      classId: map['class_id'],
      className: map['class_name'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}