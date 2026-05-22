import 'package:app/core/database/database_helper.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

class AuthLocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Cache user session after login/register
  Future<void> cacheAuthSession(AuthResponse authResponse) async {
    await _databaseHelper.insert('auth_session', {
      'userId': authResponse.userId,
      'email': authResponse.email,
      'name': authResponse.name,
      'role': authResponse.role,
      'accessToken': authResponse.accessToken,
      'refreshToken': authResponse.refreshToken,
      'tokenExpiresAt': authResponse.tokenExpiresAt,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });

    // Also cache tokens separately
    await _databaseHelper.insert('auth_tokens', {
      'accessToken': authResponse.accessToken,
      'refreshToken': authResponse.refreshToken,
      'expiresAt': authResponse.tokenExpiresAt,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    // Cache user preferences
    await _databaseHelper.insert('user_preferences', {
      'userId': authResponse.userId,
      'selectedRole': authResponse.role,
      'rememberMe': 1,
      'theme': 'light',
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Retrieve cached auth session
  Future<AuthResponse?> getCachedAuthSession() async {
    final result = await _databaseHelper.query('auth_session', limit: 1);
    if (result.isEmpty) return null;

    final session = result.first;
    return AuthResponse(
      userId: session['userId'] as String,
      email: session['email'] as String,
      name: session['name'] as String,
      role: session['role'] as String,
      accessToken: session['accessToken'] as String,
      refreshToken: session['refreshToken'] as String?,
      tokenExpiresAt: session['tokenExpiresAt'] as int?,
    );
  }

  /// Get cached access token
  Future<String?> getCachedAccessToken() async {
    final result = await _databaseHelper.query('auth_tokens', limit: 1);
    if (result.isEmpty) return null;
    return result.first['accessToken'] as String?;
  }

  /// Get cached user role
  Future<String?> getCachedUserRole() async {
    final result = await _databaseHelper.query('auth_session', limit: 1);
    if (result.isEmpty) return null;
    return result.first['role'] as String?;
  }

  /// Check if user is authenticated (has valid session)
  Future<bool> isUserAuthenticated() async {
    final session = await getCachedAuthSession();
    return session != null;
  }

  /// Update cached session (useful for token refresh)
  Future<void> updateAuthSession(AuthResponse authResponse) async {
    await _databaseHelper.update(
      'auth_session',
      {
        'accessToken': authResponse.accessToken,
        'refreshToken': authResponse.refreshToken,
        'tokenExpiresAt': authResponse.tokenExpiresAt,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'userId = ?',
      whereArgs: [authResponse.userId],
    );
  }

  /// Clear all auth cache on logout
  Future<void> clearAuthCache() async {
    await _databaseHelper.clearTable('auth_session');
    await _databaseHelper.clearTable('auth_tokens');
    await _databaseHelper.clearTable('user_preferences');
  }

  /// Get cached user preferences
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    final result = await _databaseHelper.query(
      'user_preferences',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  /// Update user preferences
  Future<void> updateUserPreferences(
    String userId, {
    String? selectedRole,
    bool? rememberMe,
    String? theme,
  }) async {
    final values = <String, dynamic>{
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
    if (selectedRole != null) values['selectedRole'] = selectedRole;
    if (rememberMe != null) values['rememberMe'] = rememberMe ? 1 : 0;
    if (theme != null) values['theme'] = theme;

    await _databaseHelper.update(
      'user_preferences',
      values,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
