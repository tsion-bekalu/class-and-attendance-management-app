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
  
  String get formattedDate {
    final month = startTime.month;
    final day = startTime.day;
    final year = startTime.year;
    final hour = startTime.hour;
    final minute = startTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$month/$day/$year at $hour12:$minute $period';
  }
}