import '../../domain/entities/attendance_entry.dart';
import '../../domain/entities/session_record.dart';

class AttendanceState {
  final List<AttendanceSession> sessions;
  final List<LiveAttendanceEntry> liveAttendance;
  final AttendanceSession? activeSession;
  final bool isSessionRunning;
  final bool isLoading;
  final String? error;

  const AttendanceState({
    this.sessions = const [],
    this.liveAttendance = const [],
    this.activeSession,
    this.isSessionRunning = false,
    this.isLoading = false,
    this.error,
  });

  AttendanceState copyWith({
    List<AttendanceSession>? sessions,
    List<LiveAttendanceEntry>? liveAttendance,
    AttendanceSession? activeSession,
    bool? isSessionRunning,
    bool? isLoading,
    String? error,
  }) {
    return AttendanceState(
      sessions: sessions ?? this.sessions,
      liveAttendance:
          liveAttendance ??
          this.liveAttendance,
      activeSession:
          activeSession ??
          this.activeSession,
      isSessionRunning:
          isSessionRunning ??
          this.isSessionRunning,
      isLoading:
          isLoading ??
          this.isLoading,
      error: error,
    );
  }
}