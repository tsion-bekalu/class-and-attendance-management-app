// features/student/presentation/providers/student_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/student/data/student_database.dart';
import 'package:app/features/student/data/student_api_service.dart';
import 'package:app/features/student/domain/models/student_models.dart';
import 'package:app/features/student/domain/repositories/student_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:app/core/providers/app_providers.dart';
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
  final authStateAsync = ref.watch(authStateProvider);

  // This extracts the AuthResponse? from your global AsyncValue state
  final authResponse = authStateAsync.value;

  if (authResponse == null) {
    throw Exception('Not authenticated: No active user session found.');
  }

  final studentId = authResponse.userId;
  final token = authResponse.accessToken;

  // Safeguard against empty data strings
  if (studentId.isEmpty || token.isEmpty) {
    throw Exception('Not authenticated: Missing valid session fields.');
  }

  return ref
      .watch(studentProfileRepositoryProvider)
      .getProfile(studentId, token);
});
// ─────────────────────────────────────────────────────────────────────────────
// Classes provider
// ─────────────────────────────────────────────────────────────────────────────

final studentClassesProvider = FutureProvider.autoDispose<List<StudentClass>>((
  ref,
) async {
  final authStateAsync = ref.watch(authStateProvider);
  final authResponse = authStateAsync.value;

  if (authResponse == null) {
    throw Exception('Not authenticated: No active user session found.');
  }

  final studentId = authResponse.userId;
  final token = authResponse.accessToken;

  if (studentId.isEmpty || token.isEmpty) {
    throw Exception('Not authenticated: Missing valid session fields.');
  }

  return ref.watch(studentClassRepositoryProvider).getClasses(studentId, token);
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
    final authState = ref.read(authStateProvider).value;
    if (authState == null || authState.userId.isEmpty)
      throw Exception('Not authenticated');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(studentClassRepositoryProvider)
          .joinClass(classCode, authState.userId, authState.accessToken);
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

// Add this after your existing providers (around line 160-170)

// ─────────────────────────────────────────────────────────────────────────────
// Mutable classes provider for UI updates
// ─────────────────────────────────────────────────────────────────────────────

// This is a separate provider that maintains a mutable list of classes for the UI
final uiStudentClassesProvider =
    StateNotifierProvider<UIClassesNotifier, AsyncValue<List<StudentClass>>>((
      ref,
    ) {
      return UIClassesNotifier(ref);
    });

class UIClassesNotifier extends StateNotifier<AsyncValue<List<StudentClass>>> {
  final Ref _ref;

  UIClassesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadInitialClasses();
  }

  void _loadInitialClasses() async {
    try {
      // Try to get real classes first
      final realClasses = await _loadRealClasses();
      if (realClasses.isNotEmpty) {
        state = AsyncValue.data(realClasses);
      } else {
        state = AsyncValue.data(_getHardcodedClasses());
      }
    } catch (e) {
      state = AsyncValue.data(_getHardcodedClasses());
    }
  }

  Future<List<StudentClass>> _loadRealClasses() async {
    try {
      final authState = _ref.read(authStateProvider).value;
      if (authState == null || authState.userId.isEmpty) {
        return [];
      }

      final classes = await _ref
          .read(studentClassRepositoryProvider)
          .getClasses(authState.userId, authState.accessToken);
      return classes;
    } catch (e) {
      return [];
    }
  }

  List<StudentClass> _getHardcodedClasses() {
    return [
      StudentClass(
        id: 'CS301',
        name: 'Data Structures & Algorithms',
        courseCode: 'CS301',
        instructorName: 'Dr. Sarah Johnson',
        attendancePercentage: 80.0,
        presentSessions: 4,
        totalSessions: 5,
        schedule: 'Monday, Wednesday, Friday\n10:00 AM - 11:30 AM',
        instructorId: '',
        roomNumber: 'TBD',
      ),
      StudentClass(
        id: 'CS305',
        name: 'Database Management Systems',
        courseCode: 'CS305',
        instructorName: 'Prof. Michael Chen',
        attendancePercentage: 0.0,
        presentSessions: 0,
        totalSessions: 0,
        schedule: 'Tuesday, Thursday\n10:00 AM - 11:30 AM',
        instructorId: '',
        roomNumber: 'TBD',
      ),
      StudentClass(
        id: 'CS308',
        name: 'Web Development',
        courseCode: 'CS308',
        instructorName: 'Dr. Emily Davis',
        attendancePercentage: 0.0,
        presentSessions: 0,
        totalSessions: 0,
        schedule: 'Wednesday, Friday\n3:30 PM - 5:00 PM',
        instructorId: '',
        roomNumber: 'TBD',
      ),
    ];
  }

  void addClass(StudentClass newClass) {
    final currentClasses = state.value ?? [];
    final updatedClasses = [...currentClasses, newClass];
    state = AsyncValue.data(updatedClasses);
  }

  void updateClasses(List<StudentClass> newClasses) {
    state = AsyncValue.data(newClasses);
  }
}

final hardcodedJoinClassProvider =
    StateNotifierProvider<HardcodedJoinNotifier, AsyncValue<void>>((ref) {
      return HardcodedJoinNotifier(ref);
    });

class HardcodedJoinNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  HardcodedJoinNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> joinClassWithCode(String classCode) async {
    if (classCode.isEmpty) return;

    state = const AsyncValue.loading();

    try {
      final newClass = StudentClass(
        id: classCode,
        name: 'Class ${classCode}',
        courseCode: classCode,
        instructorName: 'Dr. Johnson',
        attendancePercentage: 0.0,
        presentSessions: 0,
        totalSessions: 0,
        schedule: 'Monday, Wednesday, Friday\n10:00 AM - 11:30 AM',
        instructorId: '',
        roomNumber: 'TBD',
      );

      // Add the class to the UI provider
      _ref.read(uiStudentClassesProvider.notifier).addClass(newClass);

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
