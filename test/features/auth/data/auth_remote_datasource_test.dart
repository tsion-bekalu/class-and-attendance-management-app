import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/data/mock_auth_service.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

void main() {
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = AuthRemoteDataSource();
  });

  test('student login - returns auth response for valid student credentials', () async {
    final response = await remoteDataSource.login(
      LoginRequest(
        email: 'student@uni.com',
        password: 'password123',
        role: 'student',
      ),
    );

    expect(response.email, 'student@uni.com');
    expect(response.role.toLowerCase(), 'student');
    expect(response.accessToken, isNotEmpty);
    expect(response.refreshToken, isNotNull);
  });

  test('instructor login - returns auth response for valid instructor credentials', () async {
    final response = await remoteDataSource.login(
      LoginRequest(
        email: 'instructor@uni.com',
        password: 'password123',
        role: 'instructor',
      ),
    );

    expect(response.email, 'instructor@uni.com');
    expect(response.role.toLowerCase(), 'instructor');
    expect(response.accessToken, isNotEmpty);
    expect(response.refreshToken, isNotNull);
  });

  test('wrong password rejection - login throws for invalid credentials', () async {
    expect(
      () => remoteDataSource.login(
        LoginRequest(
          email: 'student@uni.com',
          password: 'wrongpassword',
          role: 'student',
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('student registration - creates new student account', () async {
    const email = 'newstudent@uni.com';
    try {
      final response = await remoteDataSource.register(
        RegisterRequest(
          name: 'New Student',
          email: email,
          password: 'password123',
          confirmPassword: 'password123',
          role: 'student',
        ),
      );

      expect(response.email, email);
      expect(response.role.toLowerCase(), 'student');
      expect(response.accessToken, isNotEmpty);
    } finally {
      MockAuthService.delete(email);
    }
  });

  test('instructor registration - creates new instructor account', () async {
    const email = 'newinstructor@uni.com';
    try {
      final response = await remoteDataSource.register(
        RegisterRequest(
          name: 'New Instructor',
          email: email,
          password: 'password123',
          confirmPassword: 'password123',
          role: 'instructor',
        ),
      );

      expect(response.email, email);
      expect(response.role.toLowerCase(), 'instructor');
      expect(response.accessToken, isNotEmpty);
    } finally {
      MockAuthService.delete(email);
    }
  });

  test('duplicate email rejection - register throws for existing email', () async {
    expect(
      () => remoteDataSource.register(
        RegisterRequest(
          name: 'Duplicate User',
          email: 'student@uni.com',
          password: 'password123',
          confirmPassword: 'password123',
          role: 'student',
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('register throws when passwords do not match', () async {
    expect(
      () => remoteDataSource.register(
        RegisterRequest(
          name: 'Bad Match',
          email: 'badmatch@uni.com',
          password: 'password123',
          confirmPassword: 'password456',
          role: 'student',
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });
}
