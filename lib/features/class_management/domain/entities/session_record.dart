class SessionAttendee {
  final String name;
  final bool isPresent;

  SessionAttendee({required this.name, required this.isPresent});
}

class AttendanceSession {
  final String date;
  final String time;
  final String attendanceCount;
  final String percentage;
  final List<SessionAttendee>? attendees;

  AttendanceSession({
    required this.date,
    required this.time,
    required this.attendanceCount,
    required this.percentage,
    this.attendees,
  });
}