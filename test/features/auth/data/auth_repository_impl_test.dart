import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';
import '../test_helpers.dart';

void main() {
  late AuthRepositoryImpl repository;

  setUpAll(() async {
    await initSqliteForTests(databaseName: 'attendance_app_test_repository.db');
  });

  setUp(() async {
    repository = AuthRepositoryImpl();
    await clearAuthTables();
  });

  tearDown(() async {
    await resetSqliteForTests();
  });

  test('login returns cached session for valid existing remote user', () async {
    final response = await repository.login(
      'student@uni.com',
      'password123',
      'student',
    );

    expect(response.email, 'student@uni.com');
    expect(response.role.toLowerCase(), 'student');

    final cached = await repository.getCachedSession();
    expect(cached, isNotNull);
    expect(cached?.email, 'student@uni.com');
  });

  test('register stores new user and caches auth session', () async {
    final email = 'integration@example.com';

    final response = await repository.register(
      'Integration User',
      email,
      'password123',
      'password123',
      'student',
    );

    expect(response.email, email);
    expect(response.accessToken, isNotEmpty);

    final cached = await repository.getCachedSession();
    expect(cached, isNotNull);
    expect(cached?.email, email);

    await repository.logout();
  });
}
