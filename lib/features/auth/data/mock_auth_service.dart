import 'package:app/core/routing/theme/models/user.dart';

class MockAuthService {
  static final List<User> mockUsers = [
    User(id: '1', name: 'Dr. Instructor', email: 'instructor@uni.com', role: UserRole.instructor),
    User(id: '2', name: 'Student  John', email: 'student@uni.com', role: UserRole.student),
  ];

  static User? login(String email) {
    try {
      return mockUsers.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }
}