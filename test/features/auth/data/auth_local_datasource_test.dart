import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';
import 'package:app/core/database/database_helper.dart';
import '../test_helpers.dart';

void main() {
  late AuthLocalDataSource localDataSource;
  late DatabaseHelper databaseHelper;

  setUpAll(() async {
    await initSqliteForTests(databaseName: 'attendance_app_test_local.db');
  });

  setUp(() async {
    localDataSource = AuthLocalDataSource();
    databaseHelper = DatabaseHelper.instance;
    await clearAuthTables();
  });

  tearDown(() async {
    await resetSqliteForTests();
  });

  test('cacheAuthSession persists session, tokens, and preferences', () async {
    final authResponse = AuthResponse(
      userId: 'user-id-1',
      email: 'student@example.com',
      name: 'Student Example',
      role: 'student',
      accessToken: 'access-token-1',
      refreshToken: 'refresh-token-1',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    );

    await localDataSource.cacheAuthSession(authResponse);

    final sessionRows = await databaseHelper.query('auth_session', limit: 1);
    expect(sessionRows, isNotEmpty);
    expect(sessionRows.first['userId'], authResponse.userId);
    expect(sessionRows.first['role'], authResponse.role);

    final tokenRows = await databaseHelper.query('auth_tokens', limit: 1);
    expect(tokenRows, isNotEmpty);
    expect(tokenRows.first['accessToken'], authResponse.accessToken);

    final preferenceRows = await databaseHelper.query('user_preferences', limit: 1);
    expect(preferenceRows, isNotEmpty);
    expect(preferenceRows.first['selectedRole'], authResponse.role);
  });

  test('student registration - saveUserAccount stores student account', () async {
    await localDataSource.saveUserAccount(
      userId: 'student-1',
      name: 'John Student',
      email: 'student@example.com',
      password: 'password123',
      role: 'student',
    );

    final response = await localDataSource.authenticateUser(
      'student@example.com',
      'password123',
    );

    expect(response, isNotNull);
    expect(response?.role, 'student');
    expect(response?.name, 'John Student');
  });

  test('instructor registration - saveUserAccount stores instructor account', () async {
    await localDataSource.saveUserAccount(
      userId: 'instructor-1',
      name: 'Dr. Sarah Instructor',
      email: 'instructor@example.com',
      password: 'password123',
      role: 'instructor',
    );

    final response = await localDataSource.authenticateUser(
      'instructor@example.com',
      'password123',
    );

    expect(response, isNotNull);
    expect(response?.role, 'instructor');
    expect(response?.name, 'Dr. Sarah Instructor');
  });

  test('duplicate email rejection - authenticateUser returns null for existing email with wrong password', () async {
    await localDataSource.saveUserAccount(
      userId: 'user-1',
      name: 'First User',
      email: 'duplicate@example.com',
      password: 'password123',
      role: 'student',
    );

    final response = await localDataSource.authenticateUser(
      'duplicate@example.com',
      'wrongpassword',
    );

    expect(response, isNull);
  });

  test('wrong password rejection - authenticateUser returns null for incorrect password', () async {
    await localDataSource.saveUserAccount(
      userId: 'user-id-2',
      name: 'Auth Tester',
      email: 'tester@example.com',
      password: 'correctpassword',
      role: 'instructor',
    );

    final response = await localDataSource.authenticateUser(
      'tester@example.com',
      'wrongpassword',
    );

    expect(response, isNull);
  });

  test('student login - authenticateUser returns correct student response', () async {
    await localDataSource.saveUserAccount(
      userId: 'student-2',
      name: 'Jane Student',
      email: 'jane@example.com',
      password: 'password123',
      role: 'student',
    );

    final response = await localDataSource.authenticateUser(
      'jane@example.com',
      'password123',
    );

    expect(response, isNotNull);
    expect(response?.email, 'jane@example.com');
    expect(response?.role, 'student');
    expect(response?.accessToken, isNotEmpty);
  });

  test('instructor login - authenticateUser returns correct instructor response', () async {
    await localDataSource.saveUserAccount(
      userId: 'instructor-2',
      name: 'Prof. John',
      email: 'prof@example.com',
      password: 'password123',
      role: 'instructor',
    );

    final response = await localDataSource.authenticateUser(
      'prof@example.com',
      'password123',
    );

    expect(response, isNotNull);
    expect(response?.email, 'prof@example.com');
    expect(response?.role, 'instructor');
    expect(response?.accessToken, isNotEmpty);
  });

  test('updateAuthSession changes cached access token', () async {
    final initial = AuthResponse(
      userId: 'user-id-3',
      email: 'update@example.com',
      name: 'Update User',
      role: 'student',
      accessToken: 'initial-token',
      refreshToken: 'initial-refresh',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
    );

    await localDataSource.cacheAuthSession(initial);

    final updated = AuthResponse(
      userId: 'user-id-3',
      email: 'update@example.com',
      name: 'Update User',
      role: 'student',
      accessToken: 'updated-token',
      refreshToken: 'updated-refresh',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch,
    );

    await localDataSource.updateAuthSession(updated);

    final sessionRows = await databaseHelper.query('auth_session', limit: 1);
    expect(sessionRows.first['accessToken'], 'updated-token');
    expect(sessionRows.first['refreshToken'], 'updated-refresh');
  });
}
