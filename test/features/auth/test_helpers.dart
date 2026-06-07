import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app/core/database/database_helper.dart';

Future<void> initSqliteForTests({String? databaseName}) async {
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  DatabaseHelper.databaseName = databaseName ??
      'attendance_app_test_${DateTime.now().microsecondsSinceEpoch}.db';

  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, DatabaseHelper.databaseName);
  await DatabaseHelper.instance.close();
  await deleteDatabase(path);
}

Future<void> resetSqliteForTests() async {
  await DatabaseHelper.instance.close();
  // Wait a bit for database to fully release resources
  await Future.delayed(const Duration(milliseconds: 100));
}

Future<void> clearAuthTables() async {
  final helper = DatabaseHelper.instance;
  await helper.clearTable('auth_session');
  await helper.clearTable('auth_tokens');
  await helper.clearTable('user_preferences');
  await helper.clearTable('user_accounts');
}
