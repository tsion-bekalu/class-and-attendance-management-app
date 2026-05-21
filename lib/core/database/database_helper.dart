import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'attendance_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        role TEXT NOT NULL,
        token TEXT,
        is_logged_in INTEGER DEFAULT 0,
        last_sync TEXT
      )
    ''');

    // Classes table
    await db.execute('''
      CREATE TABLE classes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        join_code TEXT NOT NULL UNIQUE,
        instructor_id TEXT NOT NULL,
        instructor_name TEXT NOT NULL,
        status TEXT NOT NULL,
        day TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        enrolled_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Join Requests table
    await db.execute('''
      CREATE TABLE join_requests (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        student_name TEXT NOT NULL,
        student_email TEXT NOT NULL,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        status TEXT NOT NULL,
        submitted_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Attendance Sessions table
    await db.execute('''
      CREATE TABLE attendance_sessions (
        id TEXT PRIMARY KEY,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        session_code TEXT NOT NULL,
        qr_code_data TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        total_students INTEGER DEFAULT 0,
        attended_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Attendance Records table
    await db.execute('''
      CREATE TABLE attendance_records (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        session_code TEXT NOT NULL,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        student_id TEXT NOT NULL,
        student_name TEXT NOT NULL,
        student_email TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        is_present INTEGER NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Announcements table
    await db.execute('''
      CREATE TABLE announcements (
        id TEXT PRIMARY KEY,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Enrolled Students table
    await db.execute('''
      CREATE TABLE enrolled_students (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        student_name TEXT NOT NULL,
        student_email TEXT NOT NULL,
        class_id TEXT NOT NULL,
        class_name TEXT NOT NULL,
        enrolled_at TEXT NOT NULL,
        last_updated TEXT
      )
    ''');

    // Cache metadata table
    await db.execute('''
      CREATE TABLE cache_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_classes_instructor ON classes(instructor_id)');
    await db.execute('CREATE INDEX idx_join_requests_class ON join_requests(class_id)');
    await db.execute('CREATE INDEX idx_attendance_sessions_class ON attendance_sessions(class_id)');
    await db.execute('CREATE INDEX idx_attendance_records_session ON attendance_records(session_id)');
    await db.execute('CREATE INDEX idx_attendance_records_student ON attendance_records(student_id)');
    await db.execute('CREATE INDEX idx_enrolled_students_class ON enrolled_students(class_id)');
    await db.execute('CREATE INDEX idx_enrolled_students_student ON enrolled_students(student_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Future migrations
    }
  }

  // Generic helpers
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateWhere(String table, Map<String, dynamic> data,
      {required String where, required List<dynamic> whereArgs}) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWhere(String table,
      {required String where, required List<dynamic> whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs, String? orderBy, int? limit}) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> batchInsert(String table, List<Map<String, dynamic>> dataList) async {
    final db = await database;
    final batch = db.batch();
    for (var data in dataList) {
      batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<int> count(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final result = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      columns: ['COUNT(*) as count'],
    );
    return result.first['count'] as int;
  }

  Future<bool> isTableEmpty(String table) async {
    final count = await this.count(table);
    return count == 0;
  }

  Future<int> getTableCount(String table) async {
    return await count(table);
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('attendance_records');
    await db.delete('attendance_sessions');
    await db.delete('join_requests');
    await db.delete('announcements');
    await db.delete('enrolled_students');
    await db.delete('classes');
    await db.delete('users');
    await db.delete('cache_metadata');
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  // Cache metadata helpers
  Future<void> setCacheMetadata(String key, String value) async {
    final db = await database;
    await db.insert('cache_metadata', {
      'key': key,
      'value': value,
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getCacheMetadata(String key) async {
    final db = await database;
    final result = await db.query('cache_metadata', where: 'key = ?', whereArgs: [key]);
    if (result.isEmpty) return null;
    return result.first['value'] as String;
  }

  Future<DateTime?> getLastSyncTime(String tableName) async {
    final value = await getCacheMetadata('last_sync_$tableName');
    if (value == null) return null;
    return DateTime.parse(value);
  }

  Future<void> updateLastSyncTime(String tableName) async {
    await setCacheMetadata('last_sync_$tableName', DateTime.now().toIso8601String());
  }

  Future<bool> isCacheStale(String tableName, Duration maxAge) async {
    final lastSync = await getLastSyncTime(tableName);
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync) > maxAge;
  }
}