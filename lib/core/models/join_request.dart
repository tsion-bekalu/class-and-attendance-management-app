enum RequestStatus { pending, approved, rejected }

class JoinRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String classId;
  final String className;
  final RequestStatus status;
  final DateTime submittedAt;

  JoinRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.classId,
    required this.className,
    required this.status,
    required this.submittedAt,
  });
  
  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isRejected => status == RequestStatus.rejected;
  
  String get statusText {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}