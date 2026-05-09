
enum RequestStatus { pending, approved, rejected }

class JoinRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String classId;
  final RequestStatus status;
  final DateTime submittedAt;

  JoinRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.classId,
    required this.status,
    required this.submittedAt,
  });
}

