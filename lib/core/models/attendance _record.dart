class AttendanceRecord {
  final String id;
  final String sessionId;
  final String studentId;
  final DateTime timestamp;
  final String studentName;
  final String studentEmail;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.timestamp,
    required this.studentName,
    required this.studentEmail,
    required this.isPresent,
  });

  // Helper for percentage calculation
  int get percentage => isPresent ? 100 : 0;
}