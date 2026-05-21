import 'package:attendance_app/core/database/database_helper.dart';
import 'package:attendance_app/core/models/user.dart';
import 'package:sqflite/sqflite.dart';
class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertUser(User user, {String? token}) async {
    final db = await _dbHelper.database;
    await db.insert('users', {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'role': user.role.name,
      'token': token,
      'is_logged_in': 1,
      'last_sync': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return _mapToUser(result.first);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isEmpty) return null;
    return _mapToUser(result.first);
  }

  Future<User?> getLoggedInUser() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', where: 'is_logged_in = 1', limit: 1);
    if (result.isEmpty) return null;
    return _mapToUser(result.first);
  }

  Future<String?> getUserToken(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (result.isEmpty) return null;
    return result.first['token'] as String?;
  }

  Future<void> updateUserToken(String userId, String? token) async {
    final db = await _dbHelper.database;
    await db.update('users', {'token': token}, where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> logoutUser() async {
    final db = await _dbHelper.database;
    await db.update('users', {'is_logged_in': 0, 'token': null}, where: 'is_logged_in = 1');
  }

  Future<void> deleteUser(String id) async {
    final db = await _dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('users');
  }

  User _mapToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'] == 'instructor' ? UserRole.instructor : UserRole.student,
    );
  }
}