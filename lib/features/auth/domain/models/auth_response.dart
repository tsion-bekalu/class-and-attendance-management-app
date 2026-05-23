class AuthResponse {
  final String userId;
  final String email;
  final String name;
  final String role;
  final String accessToken;
  final String? refreshToken;
  final int? tokenExpiresAt;

  AuthResponse({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'name': name,
    'role': role,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'tokenExpiresAt': tokenExpiresAt,
  };

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    userId: json['userId'] ?? json['id'] ?? '',
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    role: json['role'] ?? 'student',
    accessToken: json['accessToken'] ?? json['token'] ?? '',
    refreshToken: json['refreshToken'],
    tokenExpiresAt: json['tokenExpiresAt'],
  );
}

class LoginRequest {
  final String email;
  final String password;
  final String role;

  LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'role': role,
  };
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
    'role': role,
  };
}
