import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/attendance_entry.dart';
import '../../data/mock_attendance_data.dart';
import '../../domain/entities/attendance_entry.dart';
import '../../domain/entities/session_record.dart';
import 'attendance_state.dart';

class AttendanceNotifier
    extends StateNotifier<
        AttendanceState> {
  AttendanceNotifier()
      : super(
          const AttendanceState(),
        ) {
    loadSessions();
  }

  void loadSessions() {
    state = state.copyWith(
      sessions:
          mockAttendanceSessions,
    );
  }

  void startSession() {
    state = state.copyWith(
      isSessionRunning: true,
      liveAttendance:
          mockLiveAttendance,
    );
  }

  void markAttendance(
    LiveAttendanceEntry student,
  ) {
    final updatedList = [
      ...state.liveAttendance,
      student,
    ];

    state = state.copyWith(
      liveAttendance:
          updatedList,
    );
  }

  AttendanceSession endSession() {
    final session =
        AttendanceSession(
      date: "May 21, 2026",
      time: "10:00 AM",
      attendanceCount:
          "${state.liveAttendance.length}",
      percentage: "80%",
      attendees:
          state.liveAttendance
              .map((student) {
        return SessionAttendee(
          name:
              student.studentName,
          isPresent: true,
        );
      }).toList(),
    );

    final updatedSessions = [
      session,
      ...state.sessions,
    ];

    state = state.copyWith(
      sessions:
          updatedSessions,
      liveAttendance: [],
      activeSession: null,
      isSessionRunning: false,
    );

    return session;
  }
}

final attendanceProvider =
    StateNotifierProvider<
      AttendanceNotifier,
      AttendanceState
    >((ref) {
      return AttendanceNotifier();
    });