import 'package:app/features/student/presentation/screens/attendance_analog_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/providers/app_providers.dart';

// Instructor Screens
import 'package:app/features/class_management/presentation/screens/class_details_screen.dart';
import 'package:app/features/class_management/presentation/screens/dashboard_screen.dart';
import 'package:app/features/class_management/presentation/screens/create_class_screen.dart';
import 'package:app/features/class_management/presentation/screens/join_requests_screen.dart';
import 'package:app/features/class_management/presentation/screens/announcement.dart';
import 'package:app/features/class_management/presentation/screens/create_announcement.dart';
import 'package:app/features/class_management/presentation/screens/attendance_record_screen.dart';
import 'package:app/features/class_management/presentation/screens/start_attendance_screen.dart';
import 'package:app/features/class_management/presentation/screens/session_details_screen.dart';
import 'package:app/features/class_management/data/class_local_storage.dart';

// Auth
import 'package:app/features/auth/presentation/screens/splash.dart';
import 'package:app/features/auth/presentation/screens/role_selection.dart';
import 'package:app/features/auth/presentation/screens/login.dart';
import 'package:app/features/auth/presentation/screens/register.dart';

// Student Screens
import 'package:app/features/student/presentation/screens/notification_screen.dart';
import 'package:app/features/student/presentation/screens/student_home_screen.dart';
import 'package:app/features/student/presentation/screens/timetable_screen.dart';
import 'package:app/features/student/presentation/screens/attendance_history_screen.dart'; // Fixed: was 'attendace_history_screen.dart'
import 'package:app/features/student/presentation/screens/class_detail_screen.dart';
import 'package:app/features/student/presentation/screens/attendance_marked_screen.dart';
import 'package:app/features/class_management/domain/entities/session_record.dart';
import 'package:app/features/student/presentation/screens/attendance_enter_code_screen.dart';
import 'package:app/features/student/presentation/screens/attendance_scanner_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: _authorizeRoute,
  routes: [
    // Auth
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/role_selection',
      name: 'role_selection',
      builder: (_, _) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, state) {
        final role = state.extra as String?;

        if (role == null) {
          return const RoleSelectionScreen();
        }

        return LoginScreen(role: role);
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (_, state) {
        final role = state.extra as String?;

        if (role == null) {
          return const RoleSelectionScreen();
        }

        return RegisterScreen(role: role);
      },
    ),

    // Instructor
    GoRoute(
      path: '/instructor/dashboard',
      name: 'instructor-dashboard',
      builder: (_, _) => const InstructorDashboardScreen(),
    ),
    GoRoute(
      path: '/instructor/create-class',
      name: 'create-class',
      builder: (_, _) => const CreateClassScreen(),
    ),
    GoRoute(
      path: '/instructor/class-details/:classId',
      name: 'class-details',
      builder: (_, state) {
        final id = state.pathParameters['classId']!;
        return ClassDetailsScreen(classId: id);
      },
    ),
    GoRoute(
      path: '/instructor/timetable',
      name: 'instructor-timetable',
      builder: (_, _) => const TimetableScreen(),
    ),
    GoRoute(
      path: '/instructor/create-announcement',
      name: 'instructor-create-announcement',
      builder: (_, state) {
        final classId = state.extra as String;
        return CreateAnnouncementScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/instructor/attendance-record',
      name: 'attendance-record',
      builder: (_, state) {
        final classId = state.extra as String;
        return AttendanceRecordScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/instructor/start-attendance',
      name: 'start-attendance',
      builder: (_, state) {
        final classId = state.extra as String;
        return StartAttendanceScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/instructor/class-details/:id/join-requests',
      name: 'join-requests',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final classData = ClassLocalStorage.getClassById(id);
        return JoinRequestsScreen(
          classId: id,
          className: classData?["name"] ?? "Class",
        );
      },
    ),
    GoRoute(
      path: '/instructor/announcements',
      name: 'instructor-announcements',
      builder: (_, state) {
        final classId = state.extra as String;
        return AnnouncementsScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/instructor/session-details',
      name: 'session-details',
      builder: (_, state) {
        final session = state.extra as AttendanceSession;
        return SessionDetailsScreen(session: session);
      },
    ),

    // Student Routes
    GoRoute(
      path: '/student/home',
      name: 'student-home',
      builder: (_, _) => const StudentHomeScreen(),
    ),
    GoRoute(
      path: '/student/timetable',
      name: 'student-timetable',
      builder: (_, _) => const TimetableScreen(),
    ),
    GoRoute(
      path: '/student/attendance',
      name: 'student-attendance',
      builder: (_, state) {
        final classId = state.uri.queryParameters['classId'] ?? '';
        return AttendanceScanScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/student/attendance-history',
      name: 'student-attendance-history',
      builder: (_, state) {
        final classId = state.uri.queryParameters['classId'] ?? '';
        return AttendanceHistoryScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/student/class',
      name: 'student-class',
      builder: (_, state) {
        final classId = state.uri.queryParameters['classId'] ?? '';
        return ClassDetailScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/student/notifications',
      name: 'student-notifications',
      builder: (_, _) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/attendance-scanner-screen',
      name: 'scanner-screen',
      builder: (_, state) {
        final classId = state.uri.queryParameters['classId'] ?? '';
        return AttendanceScannerScreen(classId: classId);
      },
    ),
    GoRoute(
      path: '/attendance-manual-code-entry',
      name: 'manual-code-entry',
      builder: (_, state) {
        final classId = state.uri.queryParameters['classId'] ?? '';
        return EnterCodeScreen(classId: classId);
      },
    ),

    // Make sure you also have the attendance-marked route
    GoRoute(
      path: '/attendance-marked',
      name: 'attendance-marked',
      builder: (_, state) {
        final isPresent = state.uri.queryParameters['isPresent'] == 'true';
        final className = state.uri.queryParameters['className'] ?? '';
        final sessionTime = state.uri.queryParameters['sessionTime'] ?? '';
        final classId = state.uri.queryParameters['classId'] ?? '';

        return AttendanceMarkedScreen(
          isPresent: isPresent,
          className: className,
          sessionTime: sessionTime,
          classId: classId,
        );
      },
    ),
  ],
);

String? _authorizeRoute(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;

  if (location == '/splash' ||
      location == '/role_selection' ||
      location == '/login' ||
      location == '/register') {
    return null;
  }

  final container = ProviderScope.containerOf(context);
  final isAuthenticated = container.read(isAuthenticatedProvider);
  final role = container.read(userRoleProvider)?.toLowerCase();

  if (!isAuthenticated || role == null) {
    return '/role_selection';
  }

  final isInstructorRoute = location.startsWith('/instructor/');
  final isStudentRoute =
      location.startsWith('/student/') ||
      location == '/attendance-marked' ||
      location == '/attendance-manual-code-entry' ||
      location == '/attendance-scanner-screen';

  if (role == 'instructor' && isInstructorRoute) {
    return null;
  }

  if (role == 'student' && isStudentRoute) {
    return null;
  }

  if (role == 'instructor') {
    return '/instructor/dashboard';
  }

  return '/student/home';
}
