
import 'package:attendance_app/core/database/dao/attendance_session_dao.dart';
import 'package:attendance_app/core/database/dao/attendance_record_dao.dart';
import 'package:attendance_app/core/models/attendance_session.dart';
import 'package:attendance_app/core/models/attendance_record.dart';
import 'base_repository.dart';

class AttendanceRepository extends BaseRepository {
  final AttendanceSessionDao _sessionDao = AttendanceSessionDao();
  final AttendanceRecordDao _recordDao = AttendanceRecordDao();

  @override
  String get tableName => 'attendance_sessions';

  // Cache a single session
  Future<void> cacheSession(AttendanceSession session) async {
    await _sessionDao.insertSession(session);
  }

  // Get all cached sessions for a class
  Future<List<AttendanceSession>> getCachedSessionsByClass(String classId) async {
    return await _sessionDao.getSessionsByClass(classId);
  }

  // Get active session for a class
  Future<AttendanceSession?> getActiveSession(String classId) async {
    return await _sessionDao.getActiveSessionByClass(classId);
  }

  // Get session by code (for student scanning)
  Future<AttendanceSession?> getSessionByCode(String sessionCode) async {
    return await _sessionDao.getSessionByCode(sessionCode);
  }

  // Get session by ID
  Future<AttendanceSession?> getSessionById(String sessionId) async {
    return await _sessionDao.getSessionById(sessionId);
  }

  // End an active session
  Future<void> endSession(String sessionId) async {
    await _sessionDao.endSession(sessionId);
  }

  // Record student attendance
  Future<void> recordAttendance(AttendanceRecord record) async {
    await _recordDao.insertRecord(record);
    
    // Update session attended count
    final newCount = await _recordDao.getAttendanceCountForSession(record.sessionId);
    final session = await _sessionDao.getSessionById(record.sessionId);
    if (session != null) {
      final updatedSession = AttendanceSession(
        id: session.id,
        classId: session.classId,
        className: session.className,
        startTime: session.startTime,
        endTime: session.endTime,
        sessionCode: session.sessionCode,
        qrCodeData: session.qrCodeData,
        isActive: session.isActive,
        totalStudents: session.totalStudents,
        attendedCount: newCount,
      );
      await _sessionDao.updateSession(updatedSession);
    }
  }

  // Check if student already marked attendance
  Future<bool> hasStudentMarked(String sessionId, String studentId) async {
    return await _recordDao.hasStudentMarkedAttendance(sessionId, studentId);
  }

  // Get all attendance records for a student
  Future<List<AttendanceRecord>> getStudentAttendance(String studentId) async {
    return await _recordDao.getRecordsByStudent(studentId);
  }

  // Get attendance percentage for a student in a class
  Future<double> getAttendancePercentage(String studentId, String classId) async {
    return await _recordDao.getStudentAttendancePercentage(studentId, classId);
  }

  // Get records for a specific session
  Future<List<AttendanceRecord>> getRecordsBySession(String sessionId) async {
    return await _recordDao.getRecordsBySession(sessionId);
  }

  // Get unsynced records (for offline sync)
  Future<List<AttendanceRecord>> getUnsyncedRecords() async {
    return await _recordDao.getUnsyncedRecords();
  }

  // Mark record as synced
  Future<void> markAsSynced(String recordId) async {
    await _recordDao.markAsSynced(recordId);
  }
}