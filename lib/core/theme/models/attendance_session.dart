class AttendanceSession {
  final String id;
  final String classId;
  final String className;
  final DateTime startTime;
  final DateTime endTime;
  final String sessionCode;
  final String qrCodeData;
  final bool isActive;
  final int totalStudents;
  final int attendedCount;

  AttendanceSession({
    required this.id,
    required this.classId,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.sessionCode,
    required this.qrCodeData,
    required this.isActive,
    required this.totalStudents,
    required this.attendedCount,
  });

  double get attendancePercentage => 
      totalStudents > 0 ? (attendedCount / totalStudents) * 100 : 0;
  bool get isExpired => DateTime.now().isAfter(endTime);
  
  String get formattedDate => '${startTime.month}/${startTime.day}/${startTime.year} at ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ${startTime.hour >= 12 ? 'PM' : 'AM'}';
}
