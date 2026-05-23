// features/student/domain/repositories/student_repository.dart
import 'package:app/features/student/data/student_database.dart';
import 'package:app/features/student/data/student_api_service.dart';
import 'package:app/features/student/domain/models/student_models.dart';

/// All repositories follow the same cache-first contract:
///   1. Check SQLite cache.
///   2. If fresh → return cached data.
///   3. If stale/empty → fetch from network, persist, return.

// ── Student Profile Repository ────────────────────────────────────────────────

class StudentProfileRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  StudentProfileRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<StudentProfile> getProfile(String studentId, String token) async {
    final cached = await _db.getCachedStudentProfile(studentId);
    if (cached != null && _db.isFresh(cached['cachedAt'] as int)) {
      return StudentProfile.fromMap(cached);
    }
    final remote = await _api.fetchStudentProfile(studentId, token);
    await _db.upsertStudentProfile({...remote, 'id': studentId});
    return StudentProfile.fromMap(remote);
  }
}

// ── Classes Repository ────────────────────────────────────────────────────────

class StudentClassRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  StudentClassRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<List<StudentClass>> getClasses(
      String studentId, String token) async {
    final cached = await _db.getCachedClasses();
    if (cached.isNotEmpty &&
        _db.isFresh(cached.first['cachedAt'] as int)) {
      return cached.map(StudentClass.fromMap).toList();
    }
    final remote = await _api.fetchStudentClasses(studentId, token);
    await _db.upsertClasses(remote);
    return remote.map(StudentClass.fromMap).toList();
  }

  Future<StudentClass> getClass(
      String classId, String studentId, String token) async {
    final cached = await _db.getCachedClass(classId);
    if (cached != null && _db.isFresh(cached['cachedAt'] as int)) {
      return StudentClass.fromMap(cached);
    }
    // Refresh the full list to update the cache.
    final all = await getClasses(studentId, token);
    return all.firstWhere((c) => c.id == classId);
  }

  Future<StudentClass> joinClass(
      String classCode, String studentId, String token) async {
    final result = await _api.joinClass(classCode, studentId, token);
    final newClass = StudentClass.fromMap(result);
    await _db.upsertClasses([newClass.toMap()]);
    return newClass;
  }
}

// ── Attendance Repository ─────────────────────────────────────────────────────

class AttendanceRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  AttendanceRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<List<AttendanceHistoryEntry>> getHistory(
      String classId, String studentId, String token) async {
    final cached = await _db.getCachedAttendanceHistory(classId);
    if (cached.isNotEmpty &&
        _db.isFresh(cached.first['cachedAt'] as int)) {
      return cached.map(AttendanceHistoryEntry.fromMap).toList();
    }
    final remote =
        await _api.fetchAttendanceHistory(classId, studentId, token);
    await _db.upsertAttendanceHistory(classId, remote);
    return remote.map(AttendanceHistoryEntry.fromMap).toList();
  }

  Future<AttendanceResult> submitByCode(
      String classId, String code, String studentId, String token) async {
    final result =
        await _api.submitAttendanceCode(classId, code, studentId, token);
    return AttendanceResult(
      success: result['success'] as bool? ?? false,
      isPresent: result['isPresent'] as bool? ?? false,
      message: result['message'] as String? ?? '',
      className: result['className'] as String?,
      sessionTime: result['sessionTime'] as String?,
    );
  }

  Future<AttendanceResult> submitByQr(
      String classId, String qrData, String studentId, String token) async {
    final result =
        await _api.submitAttendanceQr(classId, qrData, studentId, token);
    return AttendanceResult(
      success: result['success'] as bool? ?? false,
      isPresent: result['isPresent'] as bool? ?? false,
      message: result['message'] as String? ?? '',
      className: result['className'] as String?,
      sessionTime: result['sessionTime'] as String?,
    );
  }
}

// ── Timetable Repository ──────────────────────────────────────────────────────

class TimetableRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  TimetableRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<List<TimetableEntry>> getTimetableForDay(
      String day, String studentId, String token) async {
    final cached = await _db.getCachedTimetable(day);
    if (cached.isNotEmpty &&
        _db.isFresh(cached.first['cachedAt'] as int)) {
      return cached.map(TimetableEntry.fromMap).toList();
    }
    final remote = await _api.fetchTimetable(studentId, token);
    await _db.upsertTimetable(remote);
    return remote
        .map(TimetableEntry.fromMap)
        .where((e) => e.day == day)
        .toList();
  }
}

// ── Notifications Repository ──────────────────────────────────────────────────

class NotificationsRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  NotificationsRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<List<NotificationModel>> getNotifications(
      String studentId, String token) async {
    final cached = await _db.getCachedNotifications();
    if (cached.isNotEmpty &&
        _db.isFresh(cached.first['cachedAt'] as int)) {
      return cached.map(NotificationModel.fromMap).toList();
    }
    final remote = await _api.fetchNotifications(studentId, token);
    await _db.upsertNotifications(remote);
    return remote.map(NotificationModel.fromMap).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _db.markNotificationRead(notificationId);
  }
}

// ── Announcements Repository ──────────────────────────────────────────────────

class AnnouncementsRepository {
  final StudentDatabase _db;
  final StudentApiService _api;

  AnnouncementsRepository({
    required StudentDatabase db,
    required StudentApiService api,
  })  : _db = db,
        _api = api;

  Future<List<Announcement>> getAnnouncements(
      String classId, String token) async {
    final cached = await _db.getCachedAnnouncements(classId);
    if (cached.isNotEmpty &&
        _db.isFresh(cached.first['cachedAt'] as int)) {
      return cached.map(Announcement.fromMap).toList();
    }
    final remote = await _api.fetchAnnouncements(classId, token);
    await _db.upsertAnnouncements(classId, remote);
    return remote.map(Announcement.fromMap).toList();
  }
}
