import 'package:app/features/auth/data/mock_auth_service.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

/// Mock implementation - Replace with actual HTTP client when API is available
class AuthRemoteDataSource {
  /// Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 1500));

  /// Login API call
  Future<AuthResponse> login(LoginRequest request) async {
    await _delay();

    final user = MockAuthService.login(request.email, request.password);
    if (user == null) {
      throw Exception('Invalid email or password');
    }

    return AuthResponse(
      userId: user.id,
      email: user.email,
      name: user.name,
      role: user.role.name,
      accessToken: 'access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    );
  }

  /// Register API call
  Future<AuthResponse> register(RegisterRequest request) async {
    await _delay();

    if (request.password != request.confirmPassword) {
      throw Exception('Passwords do not match');
    }

    final created = MockAuthService.register(
      request.name,
      request.email,
      request.password,
      request.role,
    );

    if (!created) {
      throw Exception('An account with this email already exists');
    }

    final user = MockAuthService.login(request.email, request.password);
    if (user == null) {
      throw Exception('Registration failed');
    }

    return AuthResponse(
      userId: user.id,
      email: user.email,
      name: user.name,
      role: user.role.name,
      accessToken: 'access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    );
  }

  Future<void> deleteAccount(String email) async {
    await _delay();

    final deleted = MockAuthService.delete(email);
    if (!deleted) {
      throw Exception('Account not found');
    }
  }

  /// Refresh token API call
  Future<AuthResponse> refreshToken(String refreshToken) async {
    await _delay();

    return AuthResponse(
      userId: 'user_id',
      email: 'user@example.com',
      name: 'User Name',
      role: 'student',
      accessToken: 'new_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'new_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
    );
  }

  /// Logout API call
  Future<void> logout(String accessToken) async {
    await _delay();
  }

  /// Verify token API call
  Future<bool> verifyToken(String accessToken) async {
    await _delay();
    return accessToken.isNotEmpty;
  }
}
