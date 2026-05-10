import '../domain/entities/session_record.dart';

final List<AttendanceSession> mockAttendanceSessions = [
  AttendanceSession(
    date: "Apr 11, 2026",
    time: "9:00 AM",
    attendanceCount: "4/5",
    percentage: "80%",
    attendees: [
      SessionAttendee(name: "Alice Johnson", isPresent: true),
      SessionAttendee(name: "Bob Wilson", isPresent: true),
      SessionAttendee(name: "Carol Davis", isPresent: true),
      SessionAttendee(name: "Eve Martinez", isPresent: true),
      SessionAttendee(name: "David Brown", isPresent: true),
    ],
  ),
  AttendanceSession(
    date: "Apr 9, 2026",
    time: "9:00 AM",
    attendanceCount: "4/5",
    percentage: "80%",
    attendees: [
      SessionAttendee(name: "Alice Johnson", isPresent: true),
      SessionAttendee(name: "Bob Wilson", isPresent: true),
      SessionAttendee(name: "Carol Davis", isPresent: true),
      SessionAttendee(name: "Eve Martinez", isPresent: true),
      SessionAttendee(name: "David Brown", isPresent: true),
    ],
  ),
  AttendanceSession(
    date: "Apr 7, 2026",
    time: "9:00 AM",
    attendanceCount: "3/5",
    percentage: "60%",
    attendees: [
      SessionAttendee(name: "Alice Johnson", isPresent: true),
      SessionAttendee(name: "Bob Wilson", isPresent: true),
      SessionAttendee(name: "Carol Davis", isPresent: true),
      SessionAttendee(name: "Eve Martinez", isPresent: true),
      SessionAttendee(name: "David Brown", isPresent: true),
    ],
  ),
  AttendanceSession(
    date: "Apr 4, 2026",
    time: "9:00 AM",
    attendanceCount: "5/5",
    percentage: "100%",
    attendees: [
      SessionAttendee(name: "Alice Johnson", isPresent: true),
      SessionAttendee(name: "Bob Wilson", isPresent: true),
      SessionAttendee(name: "Carol Davis", isPresent: true),
      SessionAttendee(name: "Eve Martinez", isPresent: true),
      SessionAttendee(name: "David Brown", isPresent: true),
    ],
  ),
  AttendanceSession(
    date: "Apr 2, 2026",
    time: "9:00 AM",
    attendanceCount: "3/5",
    percentage: "60%",
    attendees: [
      SessionAttendee(name: "Alice Johnson", isPresent: true),
      SessionAttendee(name: "Bob Wilson", isPresent: true),
      SessionAttendee(name: "Carol Davis", isPresent: true),
      SessionAttendee(name: "Eve Martinez", isPresent: true),
      SessionAttendee(name: "David Brown", isPresent: true),
    ],
  ),
];