// features/student/presentation/providers/student_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/student/data/student_database.dart';
import 'package:app/features/student/data/student_api_service.dart';
import 'package:app/features/student/domain/models/student_models.dart';
import 'package:app/features/student/domain/repositories/student_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
// ─────────────────────────────────────────────────────────────────────────────
// Infrastructure providers
// ─────────────────────────────────────────────────────────────────────────────

final studentDatabaseProvider = Provider<StudentDatabase>((ref) {
  return StudentDatabase();
});

final studentApiServiceProvider = Provider<StudentApiService>((ref) {
  return StudentApiService();
});

// ─────────────────────────────────────────────────────────────────────────────
// Repository providers
// ─────────────────────────────────────────────────────────────────────────────

final studentProfileRepositoryProvider = Provider<StudentProfileRepository>((
  ref,
) {
  return StudentProfileRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

final studentClassRepositoryProvider = Provider<StudentClassRepository>((ref) {
  return StudentClassRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

final announcementsRepositoryProvider = Provider<AnnouncementsRepository>((
  ref,
) {
  return AnnouncementsRepository(
    db: ref.watch(studentDatabaseProvider),
    api: ref.watch(studentApiServiceProvider),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Auth – current user token & id (set after login, read everywhere)
// ─────────────────────────────────────────────────────────────────────────────

class AuthState {
  final String? studentId;
  final String? token;

  const AuthState({this.studentId, this.token});

  bool get isLoggedIn => studentId != null && token != null;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void setAuth(String studentId, String token) {
    state = AuthState(studentId: studentId, token: token);
  }

  void clearAuth() => state = const AuthState();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// Student profile provider
// ─────────────────────────────────────────────────────────────────────────────

final studentProfileProvider = FutureProvider.autoDispose<StudentProfile>((
  ref,
) async {
  final auth = ref.watch(authProvider);
  if (!auth.isLoggedIn) throw Exception('Not authenticated');
  return ref
      .watch(studentProfileRepositoryProvider)
      .getProfile(auth.studentId!, auth.token!);
});

// ─────────────────────────────────────────────────────────────────────────────
// Classes provider
// ─────────────────────────────────────────────────────────────────────────────

final studentClassesProvider = FutureProvider.autoDispose<List<StudentClass>>((
  ref,
) async {
  final auth = ref.watch(authProvider);
  if (!auth.isLoggedIn) throw Exception('Not authenticated');
  return ref
      .watch(studentClassRepositoryProvider)
      .getClasses(auth.studentId!, auth.token!);
});

// Single class detail (takes classId as family parameter)
final classDetailProvider = FutureProvider.autoDispose
    .family<StudentClass, String>((ref, classId) async {
      final auth = ref.watch(authProvider);
      if (!auth.isLoggedIn) throw Exception('Not authenticated');
      return ref
          .watch(studentClassRepositoryProvider)
          .getClass(classId, auth.studentId!, auth.token!);
    });

// ─────────────────────────────────────────────────────────────────────────────
// Join class notifier
// ─────────────────────────────────────────────────────────────────────────────

class JoinClassNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> joinClass(String classCode) async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn) throw Exception('Not authenticated');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(studentClassRepositoryProvider)
          .joinClass(classCode, auth.studentId!, auth.token!);
      // Invalidate the classes list so it refreshes.
      ref.invalidate(studentClassesProvider);
    });
  }
}

final joinClassProvider = AsyncNotifierProvider<JoinClassNotifier, void>(
  JoinClassNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// Attendance history provider (per class)
// ─────────────────────────────────────────────────────────────────────────────

final attendanceHistoryProvider = FutureProvider.autoDispose
    .family<List<AttendanceHistoryEntry>, String>((ref, classId) async {
      final auth = ref.watch(authProvider);
      if (!auth.isLoggedIn) throw Exception('Not authenticated');
      return ref
          .watch(attendanceRepositoryProvider)
          .getHistory(classId, auth.studentId!, auth.token!);
    });

// ─────────────────────────────────────────────────────────────────────────────
// Attendance submission notifier
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceSubmissionNotifier extends AsyncNotifier<AttendanceResult?> {
  @override
  Future<AttendanceResult?> build() async => null;

  Future<void> submitByCode(String classId, String code) async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn) throw Exception('Not authenticated');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(attendanceRepositoryProvider)
          .submitByCode(classId, code, auth.studentId!, auth.token!);
      // Refresh attendance history for this class.
      ref.invalidate(attendanceHistoryProvider(classId));
      return result;
    });
  }

  Future<void> submitByQr(String classId, String qrData) async {
    final auth = ref.read(authProvider);
    if (!auth.isLoggedIn) throw Exception('Not authenticated');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(attendanceRepositoryProvider)
          .submitByQr(classId, qrData, auth.studentId!, auth.token!);
      ref.invalidate(attendanceHistoryProvider(classId));
      return result;
    });
  }

  void reset() => state = const AsyncData(null);
}

final attendanceSubmissionProvider =
    AsyncNotifierProvider<AttendanceSubmissionNotifier, AttendanceResult?>(
      AttendanceSubmissionNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Timetable – selected day state + data
// ─────────────────────────────────────────────────────────────────────────────

final selectedDayProvider = StateProvider<String>((ref) {
  // Default to today's abbreviated weekday.
  const dayMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };
  return dayMap[DateTime.now().weekday] ?? 'Mon';
});

final timetableProvider = FutureProvider.autoDispose<List<TimetableEntry>>((
  ref,
) async {
  final auth = ref.watch(authProvider);
  final day = ref.watch(selectedDayProvider);
  if (!auth.isLoggedIn) throw Exception('Not authenticated');
  return ref
      .watch(timetableRepositoryProvider)
      .getTimetableForDay(day, auth.studentId!, auth.token!);
});

// ─────────────────────────────────────────────────────────────────────────────
// Notifications
// ─────────────────────────────────────────────────────────────────────────────

final notificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
      final auth = ref.watch(authProvider);
      if (!auth.isLoggedIn) throw Exception('Not authenticated');
      return ref
          .watch(notificationsRepositoryProvider)
          .getNotifications(auth.studentId!, auth.token!);
    });

final hasUnreadNotificationsProvider = Provider.autoDispose<bool>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.maybeWhen(
    data: (list) => list.any((n) => n.isUnread),
    orElse: () => false,
  );
});

class NotificationsNotifier extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isLoggedIn) return [];
    return ref
        .read(notificationsRepositoryProvider)
        .getNotifications(auth.studentId!, auth.token!);
  }

  Future<void> markAsRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markAsRead(id);
    state = AsyncData(
      state.value
              ?.map((n) => n.id == id ? n.copyWith(isUnread: false) : n)
              .toList() ??
          [],
    );
  }
}

final notificationsNotifierProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
      NotificationsNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Announcements (per class)
// ─────────────────────────────────────────────────────────────────────────────

final announcementsProvider = FutureProvider.autoDispose
    .family<List<Announcement>, String>((ref, classId) async {
      final auth = ref.watch(authProvider);
      if (!auth.isLoggedIn) throw Exception('Not authenticated');
      return ref
          .watch(announcementsRepositoryProvider)
          .getAnnouncements(classId, auth.token!);
    });
