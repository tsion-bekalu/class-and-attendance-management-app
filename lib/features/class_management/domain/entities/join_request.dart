enum JoinRequestStatus { pending, approved, rejected }

class JoinRequest {
  final String name;
  final String email;
  final String studentId;
  final JoinRequestStatus status;

  JoinRequest({
    required this.name,
    required this.email,
    required this.studentId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "studentId": studentId,
      "status": status.name,
    };
  }

  factory JoinRequest.fromMap(Map<String, dynamic> map) {
    return JoinRequest(
      name: map["name"],
      email: map["email"],
      studentId: map["studentId"],
      status: JoinRequestStatus.values.firstWhere(
        (e) => e.name == map["status"],
      ),
    );
  }
}
