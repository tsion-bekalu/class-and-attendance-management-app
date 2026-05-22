import 'package:app/features/auth/domain/models/auth_response.dart';

/// Mock implementation - Replace with actual HTTP client when API is available
class AuthRemoteDataSource {
  /// Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 1500));

  /// Login API call
  Future<AuthResponse> login(LoginRequest request) async {
    await _delay();

    // Mock data - Replace with actual API call using http/dio
    // Example:
    // final response = await httpClient.post(
    //   '/api/auth/login',
    //   data: request.toJson(),
    // );

    // Mock successful login
    if (request.email.isNotEmpty && request.password.isNotEmpty) {
      return AuthResponse(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: request.email,
        name: request.email.split('@').first,
        role: request.role,
        accessToken: 'access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      );
    }

    throw Exception('Invalid credentials');
  }

  /// Register API call
  Future<AuthResponse> register(RegisterRequest request) async {
    await _delay();

    // Mock data - Replace with actual API call
    // Example:
    // final response = await httpClient.post(
    //   '/api/auth/register',
    //   data: request.toJson(),
    // );

    if (request.name.isNotEmpty &&
        request.email.isNotEmpty &&
        request.password.isNotEmpty &&
        request.password == request.confirmPassword) {
      return AuthResponse(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: request.email,
        name: request.name,
        role: request.role,
        accessToken: 'access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        tokenExpiresAt: DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      );
    }

    throw Exception('Registration failed');
  }

  /// Refresh token API call
  Future<AuthResponse> refreshToken(String refreshToken) async {
    await _delay();

    // Mock refresh - Replace with actual API call
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
    // Mock logout - Replace with actual API call if needed
  }

  /// Verify token API call
  Future<bool> verifyToken(String accessToken) async {
    await _delay();
    // Mock verification - Replace with actual API call
    return accessToken.isNotEmpty;
  }
}
