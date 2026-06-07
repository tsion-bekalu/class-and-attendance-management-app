import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/providers/app_providers.dart';
import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await initSqliteForTests(databaseName: 'attendance_app_test_provider.db');
  });

  setUp(() async {
    await clearAuthTables();
  });

  tearDown(() async {
    await resetSqliteForTests();
  });

  test('auth state after student login - authStateProvider updates with student credentials', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authStateProvider.notifier).login(
      'student@uni.com',
      'password123',
      'student',
    );

    final state = container.read(authStateProvider);
    expect(state.hasValue, isTrue);
    expect(state.value?.email, 'student@uni.com');
    expect(state.value?.role.toLowerCase(), 'student');
    expect(state.value?.accessToken, isNotEmpty);
  });

  test('auth state after instructor login - authStateProvider updates with instructor credentials', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authStateProvider.notifier).login(
      'instructor@uni.com',
      'password123',
      'instructor',
    );

    final state = container.read(authStateProvider);
    expect(state.hasValue, isTrue);
    expect(state.value?.email, 'instructor@uni.com');
    expect(state.value?.role.toLowerCase(), 'instructor');
    expect(state.value?.accessToken, isNotEmpty);
  });

  test('logout clears state - authStateProvider resets to null after logout', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authStateProvider.notifier).login(
      'student@uni.com',
      'password123',
      'student',
    );

    expect(container.read(authStateProvider).value, isNotNull);

    await container.read(authStateProvider.notifier).logout();

    final state = container.read(authStateProvider);
    expect(state.hasValue, isTrue);
    expect(state.value, isNull);
  });
}
