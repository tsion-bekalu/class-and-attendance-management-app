class AttendanceRecord {
  final String id;
  final String sessionId;
  final String sessionCode;
  final String classId;
  final String className;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final DateTime timestamp;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.sessionCode,
    required this.classId,
    required this.className,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.timestamp,
    required this.isPresent,
  });

  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }
}