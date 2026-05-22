import 'package:app/features/auth/domain/models/auth_response.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResponse> login(String email, String password, String role);

  /// Register new user
  Future<AuthResponse> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  );

  /// Logout current user
  Future<void> logout();

  /// Get cached user session (if available)
  Future<AuthResponse?> getCachedSession();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get current user role
  Future<String?> getUserRole();

  /// Refresh access token
  Future<AuthResponse> refreshAccessToken();

  /// Verify if current token is still valid
  Future<bool> verifyToken();
}
