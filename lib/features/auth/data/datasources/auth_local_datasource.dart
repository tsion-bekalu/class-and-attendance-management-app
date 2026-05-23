import 'package:app/core/database/database_helper.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

class AuthLocalDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  /// Cache user session after login/register
  Future<void> cacheAuthSession(AuthResponse authResponse) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final existingSession = await _databaseHelper.query(
      'auth_session',
      where: 'userId = ?',
      whereArgs: [authResponse.userId],
      limit: 1,
    );

    final sessionValues = {
      'userId': authResponse.userId,
      'email': authResponse.email,
      'name': authResponse.name,
      'role': authResponse.role,
      'accessToken': authResponse.accessToken,
      'refreshToken': authResponse.refreshToken,
      'tokenExpiresAt': authResponse.tokenExpiresAt,
      'createdAt': existingSession.isEmpty ? now : existingSession.first['createdAt'],
      'updatedAt': now,
    };

    if (existingSession.isEmpty) {
      await _databaseHelper.insert('auth_session', sessionValues);
    } else {
      await _databaseHelper.update(
        'auth_session',
        sessionValues,
        where: 'userId = ?',
        whereArgs: [authResponse.userId],
      );
    }

    final existingTokens = await _databaseHelper.query('auth_tokens', limit: 1);
    final tokenValues = {
      'accessToken': authResponse.accessToken,
      'refreshToken': authResponse.refreshToken,
      'expiresAt': authResponse.tokenExpiresAt,
      'createdAt': existingTokens.isEmpty ? now : existingTokens.first['createdAt'],
    };

    if (existingTokens.isEmpty) {
      await _databaseHelper.insert('auth_tokens', tokenValues);
    } else {
      await _databaseHelper.update(
        'auth_tokens',
        tokenValues,
        where: 'id = ?',
        whereArgs: [existingTokens.first['id']],
      );
    }

    final existingPreferences = await _databaseHelper.query(
      'user_preferences',
      where: 'userId = ?',
      whereArgs: [authResponse.userId],
      limit: 1,
    );

    final preferenceValues = {
      'userId': authResponse.userId,
      'selectedRole': authResponse.role,
      'rememberMe': 1,
      'theme': 'light',
      'updatedAt': now,
    };

    if (existingPreferences.isEmpty) {
      await _databaseHelper.insert('user_preferences', preferenceValues);
    } else {
      await _databaseHelper.update(
        'user_preferences',
        preferenceValues,
        where: 'userId = ?',
        whereArgs: [authResponse.userId],
      );
    }
  }

  /// Save a registered or fallback user account for persistent login validation.
  Future<void> saveUserAccount({
    required String userId,
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final existing = await getUserByEmail(normalizedEmail);
    final existingByUserId = existing == null
        ? await getUserByUserId(userId)
        : null;
    final target = existing ?? existingByUserId;

    if (target != null) {
      await _databaseHelper.update(
        'user_accounts',
        {
          'userId': userId,
          'name': name,
          'email': normalizedEmail,
          'password': password,
          'role': role,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [target['id']],
      );
      return;
    }

    await _databaseHelper.insert('user_accounts', {
      'userId': userId,
      'name': name,
      'email': normalizedEmail,
      'password': password,
      'role': role,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Authenticate using the persisted user accounts table.
  Future<AuthResponse?> authenticateUser(String email, String password) async {
    final user = await getUserByEmail(_normalizeEmail(email));

    if (user == null || user['password'] != password) {
      return null;
    }

    final userId = user['userId'] as String;
    final name = user['name'] as String;
    final role = user['role'] as String;

    return AuthResponse(
      userId: userId,
      email: email,
      name: name,
      role: role,
      accessToken: 'local_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'local_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final normalizedEmail = _normalizeEmail(email);
    final result = await _databaseHelper.query(
      'user_accounts',
      where: 'LOWER(email) = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );

    return result.isEmpty ? null : result.first;
  }

  Future<Map<String, dynamic>?> getUserByUserId(String userId) async {
    final result = await _databaseHelper.query(
      'user_accounts',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );

    return result.isEmpty ? null : result.first;
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

  Future<void> deleteUserByEmail(String email) async {
    await _databaseHelper.delete(
      'user_accounts',
      where: 'LOWER(email) = ?',
      whereArgs: [_normalizeEmail(email)],
    );
  }
}
