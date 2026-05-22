import 'package:flutter_riverpod/legacy.dart';

import '../../data/attendance_database.dart';
import '../../domain/entities/session_record.dart';

final attendanceProvider =
    StateNotifierProvider.family<
      AttendanceNotifier,
      List<AttendanceSession>,
      String
    >((ref, classId) {
      return AttendanceNotifier(classId);
    });

class AttendanceNotifier extends StateNotifier<List<AttendanceSession>> {
  final AttendanceDatabase _database = AttendanceDatabase();

  final String classId;

  AttendanceNotifier(this.classId) : super([]) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    final sessions = await _database.getSessions(classId);

    state = sessions;
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
