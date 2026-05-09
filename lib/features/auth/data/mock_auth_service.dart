import 'package:app/core/models/user.dart';

class MockAuthService {
  static final List<User> mockUsers = [
    User(
      id: '1',
      name: 'Dr. Sarah Johnson',
      email: 'instructor@uni.com',
      password: 'password123',
      role: UserRole.instructor,
    ),
    User(
      id: '2',
      name: 'John Smith',
      email: 'student@uni.com',
      password: 'password123',
      role: UserRole.student,
    ),
  ];

  static User? login(String email, String password) {
    try {
      return mockUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static bool register(String name, String email, String password, String role) {
    try {
    
      final exists = mockUsers.any((u) => u.email == email);
      if (exists) {
        return false;
      }

      // Create new user
      final newUser = User(
        id: '${mockUsers.length + 1}',
        name: name,
        email: email,
        password: password,
        role: role.toLowerCase() == 'instructor'
            ? UserRole.instructor
            : UserRole.student,
      );

      mockUsers.add(newUser);
      return true;
    } catch (e) {
      return false;
    }
  }
}