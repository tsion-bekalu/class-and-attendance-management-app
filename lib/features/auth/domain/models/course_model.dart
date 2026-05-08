

class Course {
  final String name;
  final String code;
  final String schedule;
  final int studentCount;
  final bool hasPendingRequests;
  final bool isActive;

  Course({
    required this.name,
    required this.code,
    required this.schedule,
    required this.studentCount,
    this.hasPendingRequests = false,
    this.isActive = true,
  });
}

// MOCK DATABASE
final List<Course> mockCourses = [
  Course(
    name: 'Computer Science 101',
    code: 'CS101XYZ',
    schedule: 'Mon, Wed, Fri - 9:00 AM',
    studentCount: 45,
    hasPendingRequests: true,
  ),
  Course(
    name: 'Data Structures',
    code: 'DS201ABC',
    schedule: 'Tue, Thu - 2:00 PM',
    studentCount: 32,
    hasPendingRequests: false,
  ),
];