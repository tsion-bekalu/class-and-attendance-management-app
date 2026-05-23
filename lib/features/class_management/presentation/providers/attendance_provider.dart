import 'package:flutter_riverpod/legacy.dart';
import '../../data/attendance_database.dart';
import '../../domain/entities/attendance_entry.dart';
import '../../domain/entities/session_record.dart';

final attendanceProvider =
    StateNotifierProvider.family<AttendanceNotifier, AttendanceState, String>((
      ref,
      classId,
    ) {
      return AttendanceNotifier(classId);
    });

class AttendanceState {
  final List<AttendanceSession> sessions;
  final List<LiveAttendanceEntry> liveAttendance;

  const AttendanceState({
    this.sessions = const [],
    this.liveAttendance = const [],
  });

  AttendanceState copyWith({
    List<AttendanceSession>? sessions,
    List<LiveAttendanceEntry>? liveAttendance,
  }) {
    return AttendanceState(
      sessions: sessions ?? this.sessions,
      liveAttendance: liveAttendance ?? this.liveAttendance,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceDatabase _database;
  final String classId;

  AttendanceNotifier(this.classId)
    : _database = AttendanceDatabase(),
      super(const AttendanceState()) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    final sessions = await _database.getSessions(classId);

    state = state.copyWith(sessions: sessions);
  }

  void startSession() {
    state = state.copyWith(liveAttendance: []);

  }

  AttendanceSession endSession() {

    final session = AttendanceSession(
      classId: classId,
      date: DateTime.now().toString().split(' ').first,
time:
    "${DateTime.now().hour}:${DateTime.now().minute}",      attendanceCount: state.liveAttendance.length.toString(),
      percentage: "100%",
      attendees: state.liveAttendance
          .map((e) => SessionAttendee(name: e.studentName, isPresent: true))
          .toList(),
    );

    addSession(session);

    return session;
  }

  Future<void> addSession(AttendanceSession session) async {
    await _database.insertSession(session);

    await loadSessions();
  }

  Future<void> deleteSession(int id) async {
    await _database.deleteSession(id);

    await loadSessions();
  }
}
