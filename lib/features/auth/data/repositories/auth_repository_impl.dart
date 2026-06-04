import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  @override
  Future<AuthResponse> login(String email, String password, String role) async {
    try {
      final localAuth = await _localDataSource.authenticateUser(
        email,
        password,
      );
      if (localAuth != null) {
        await _localDataSource.cacheAuthSession(localAuth);
        return localAuth;
      }

      final request = LoginRequest(
        email: email,
        password: password,
        role: role,
      );

      final authResponse = await _remoteDataSource.login(request);
      await _localDataSource.saveUserAccount(
        userId: authResponse.userId,
        name: authResponse.name,
        email: authResponse.email,
        password: password,
        role: authResponse.role,
      );
      await _localDataSource.cacheAuthSession(authResponse);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
      );

      final authResponse = await _remoteDataSource.register(request);
      await _localDataSource.saveUserAccount(
        userId: authResponse.userId,
        name: authResponse.name,
        email: authResponse.email,
        password: password,
        role: authResponse.role,
      );
      await _localDataSource.cacheAuthSession(authResponse);

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _localDataSource.getCachedAccessToken();

      if (token != null && token.isNotEmpty) {
        try {
          await _remoteDataSource.logout(token);
        } catch (_) {}
      }
    } catch (_) {}

    await _localDataSource.clearAuthCache();
  }

  @override
  @override
  Future<void> deleteAccount() async {
    final session = await _localDataSource.getCachedAuthSession();

    if (session == null) {
      return;
    }

    try {
      try {
        await _remoteDataSource.deleteAccount(session.email);
      } catch (_) {}

      if (session.role.toLowerCase() == 'instructor') {
        await _localDataSource.cleanupInstructorData(session.userId);
      } else {
        await _localDataSource.cleanupStudentData(session.userId);
      }

      await _localDataSource.deleteUserByEmail(session.email);

      await _localDataSource.clearAuthCache();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse?> getCachedSession() async {
    // Cache hit - retrieve from local storage first
    return await _localDataSource.getCachedAuthSession();
  }

  @override
  Future<bool> isAuthenticated() async {
    // First check local cache
    final isAuthenticated = await _localDataSource.isUserAuthenticated();

    if (isAuthenticated) {
      // Optionally verify with server (cache miss - optional)
      try {
        final token = await _localDataSource.getCachedAccessToken();
        if (token != null) {
          return await _remoteDataSource.verifyToken(token);
        }
      } catch (e) {
        // If verification fails but we have cache, still consider authenticated
        return true;
      }
    }

    return isAuthenticated;
  }

  @override
  Future<String?> getUserRole() async {
    // Cache hit - get from local storage
    return await _localDataSource.getCachedUserRole();
  }

  @override
  Future<AuthResponse> refreshAccessToken() async {
    try {
      final cachedSession = await _localDataSource.getCachedAuthSession();

      if (cachedSession?.refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Make network request to refresh
      final newAuthResponse = await _remoteDataSource.refreshToken(
        cachedSession!.refreshToken!,
      );

      // Update cache with new tokens
      await _localDataSource.updateAuthSession(newAuthResponse);

      return newAuthResponse;
    } catch (e) {
      // If refresh fails, logout user
      await logout();
      rethrow;
    }
  }

  @override
  Future<bool> verifyToken() async {
    try {
      final token = await _localDataSource.getCachedAccessToken();

      if (token == null) {
        return false;
      }

      // Verify with server (cache miss scenario)
      return await _remoteDataSource.verifyToken(token);
    } catch (e) {
      return false;
    }
  }
}
