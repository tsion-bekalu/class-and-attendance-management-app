// features/student/domain/models/student_models.dart
import 'package:flutter/material.dart';

// ── Student Profile ───────────────────────────────────────────────────────────

class StudentProfile {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final double overallAttendance;
  final int presentSessions;
  final int absentSessions;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.overallAttendance,
    required this.presentSessions,
    required this.absentSessions,
  });

  factory StudentProfile.fromMap(Map<String, dynamic> m) => StudentProfile(
        id: m['id'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        studentId: m['studentId'] as String,
        overallAttendance: (m['overallAttendance'] as num).toDouble(),
        presentSessions: m['presentSessions'] as int,
        absentSessions: m['absentSessions'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'studentId': studentId,
        'overallAttendance': overallAttendance,
        'presentSessions': presentSessions,
        'absentSessions': absentSessions,
      };
}

// ── Class Model ───────────────────────────────────────────────────────────────

class StudentClass {
  final String id;
  final String name;
  final String courseCode;
  final String instructorId;
  final String instructorName;
  final String schedule;
  final String roomNumber;
  final double attendancePercentage;
  final int presentSessions;
  final int totalSessions;

  const StudentClass({
    required this.id,
    required this.name,
    required this.courseCode,
    required this.instructorId,
    required this.instructorName,
    required this.schedule,
    required this.roomNumber,
    required this.attendancePercentage,
    required this.presentSessions,
    required this.totalSessions,
  });

  factory StudentClass.fromMap(Map<String, dynamic> m) => StudentClass(
        id: m['id'] as String,
        name: m['name'] as String,
        courseCode: m['courseCode'] as String,
        instructorId: m['instructorId'] as String,
        instructorName: m['instructorName'] as String,
        schedule: m['schedule'] as String,
        roomNumber: m['roomNumber'] as String,
        attendancePercentage:
            (m['attendancePercentage'] as num).toDouble(),
        presentSessions: m['presentSessions'] as int,
        totalSessions: m['totalSessions'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'courseCode': courseCode,
        'instructorId': instructorId,
        'instructorName': instructorName,
        'schedule': schedule,
        'roomNumber': roomNumber,
        'attendancePercentage': attendancePercentage,
        'presentSessions': presentSessions,
        'totalSessions': totalSessions,
      };
}

// ── Attendance History Entry ───────────────────────────────────────────────────

class AttendanceHistoryEntry {
  final String id;
  final String classId;
  final String topic;
  final String date;
  final bool isPresent;
  final String? sessionCode;

  const AttendanceHistoryEntry({
    required this.id,
    required this.classId,
    required this.topic,
    required this.date,
    required this.isPresent,
    this.sessionCode,
  });

  factory AttendanceHistoryEntry.fromMap(Map<String, dynamic> m) =>
      AttendanceHistoryEntry(
        id: m['id'] as String,
        classId: m['classId'] as String,
        topic: m['topic'] as String,
        date: m['date'] as String,
        isPresent: (m['isPresent'] as int) == 1,
        sessionCode: m['sessionCode'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'classId': classId,
        'topic': topic,
        'date': date,
        'isPresent': isPresent ? 1 : 0,
        'sessionCode': sessionCode,
      };
}

// ── Notification Model ────────────────────────────────────────────────────────

enum NotificationType { attendance, announcement, reminder, general }

class NotificationModel {
  final String id;
  final String courseCode;
  final String courseName;
  final String title;
  final String description;
  final String timeAgo;
  final NotificationType type;
  final bool isUnread;

  const NotificationModel({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
    required this.isUnread,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> m) =>
      NotificationModel(
        id: m['id'] as String,
        courseCode: m['courseCode'] as String,
        courseName: m['courseName'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        timeAgo: m['timeAgo'] as String,
        type: NotificationType.values.firstWhere(
          (e) => e.name == (m['type'] as String),
          orElse: () => NotificationType.general,
        ),
        isUnread: (m['isUnread'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'courseCode': courseCode,
        'courseName': courseName,
        'title': title,
        'description': description,
        'timeAgo': timeAgo,
        'type': type.name,
        'isUnread': isUnread ? 1 : 0,
      };

  NotificationModel copyWith({bool? isUnread}) => NotificationModel(
        id: id,
        courseCode: courseCode,
        courseName: courseName,
        title: title,
        description: description,
        timeAgo: timeAgo,
        type: type,
        isUnread: isUnread ?? this.isUnread,
      );
}

// ── Timetable Entry ───────────────────────────────────────────────────────────

class TimetableEntry {
  final String id;
  final String classId;
  final String day;
  final String title;
  final String courseCode;
  final String time;
  final String location;
  final String duration;
  final Color accentColor;

  const TimetableEntry({
    required this.id,
    required this.classId,
    required this.day,
    required this.title,
    required this.courseCode,
    required this.time,
    required this.location,
    required this.duration,
    required this.accentColor,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> m) => TimetableEntry(
        id: m['id'] as String,
        classId: m['classId'] as String,
        day: m['day'] as String,
        title: m['title'] as String,
        courseCode: m['courseCode'] as String,
        time: m['time'] as String,
        location: m['location'] as String,
        duration: m['duration'] as String,
        accentColor: Color(m['accentColor'] as int),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'classId': classId,
        'day': day,
        'title': title,
        'courseCode': courseCode,
        'time': time,
        'location': location,
        'duration': duration,
        'accentColor': accentColor.value,
      };
}

// ── Announcement ──────────────────────────────────────────────────────────────

class Announcement {
  final String id;
  final String classId;
  final String title;
  final String description;
  final String dateTime;

  const Announcement({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  factory Announcement.fromMap(Map<String, dynamic> m) => Announcement(
        id: m['id'] as String,
        classId: m['classId'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        dateTime: m['dateTime'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'classId': classId,
        'title': title,
        'description': description,
        'dateTime': dateTime,
      };
}

// ── Attendance Submission Result ──────────────────────────────────────────────

class AttendanceResult {
  final bool success;
  final bool isPresent;
  final String message;
  final String? className;
  final String? sessionTime;

  const AttendanceResult({
    required this.success,
    required this.isPresent,
    required this.message,
    this.className,
    this.sessionTime,
  });
}
