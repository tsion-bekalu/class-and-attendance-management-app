import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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
import 'package:app/features/student/presentation/screens/attendace_history_screen.dart';
import 'package:app/features/student/presentation/screens/class_detail_screen.dart';
import 'package:app/features/student/presentation/screens/attendance_marked_screen.dart';
import 'package:app/features/student/presentation/screens/attendance_qr_screen.dart';
import 'package:app/features/class_management/domain/entities/session_record.dart';


class EditClassScreen extends StatelessWidget {
  final String classId;
  const EditClassScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Edit Class $classId')));
}

class StartSessionScreen extends StatelessWidget {
  final String classId;
  const StartSessionScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Start Session $classId')));
}

class QRDisplayScreen extends StatelessWidget {
  final String sessionId;
  const QRDisplayScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('QR $sessionId')));
}

class EnterJoinCodeScreen extends StatelessWidget {
  const EnterJoinCodeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Join Code')));
}

class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Student Attendance')));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/student/home',
  routes: [
    // Auth
    GoRoute(path: '/splash', name: 'splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/role_selection', name: 'role_selection', builder: (_, _) => const RoleSelectionScreen()),
    GoRoute(path: '/login', name: 'login', builder: (_, state) => LoginScreen(role: state.extra as String)),
    GoRoute(path: '/register', name: 'register', builder: (_, state) => RegisterScreen(role: state.extra as String)),

    // Instructor
    GoRoute(path: '/instructor/dashboard', name: 'instructor-dashboard', builder: (_,_) => const InstructorDashboardScreen()),
    GoRoute(path: '/instructor/create-class', name: 'create-class', builder: (_,_) => const CreateClassScreen()),
    GoRoute(path: '/instructor/class-details/:classId', name: 'class-details', builder: (_,state){
      final id = state.pathParameters['classId']!; 
      return ClassDetailsScreen(classId: id);} ),
    GoRoute(path: '/instructor/start-session/:classId', name: 'instructor-start-session', builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/qr-display/:sessionId', name: 'instructor-qr-display', builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!)),
    GoRoute(path: '/instructor/timetable', name: 'instructor-timetable', builder: (_, __) => const TimetableScreen()),
    GoRoute(path: '/instructor/create-announcement',name: 'instructor-create-announcement',builder: (context, state) => const CreateAnnouncementScreen(),),
    GoRoute(path: '/instructor/attendance-record',name: 'attendance-record',builder: (context, state) => const AttendanceRecordScreen(),),
    GoRoute(path: '/instructor/start-attendance',name: 'start-attendance',builder: (context, state) => const StartAttendanceScreen(),),
    GoRoute(path: '/instructor/class-details/:id/join-requests',name: 'join-requests',builder: (context, state) {
        final id = state.pathParameters['id']!;
        final classData = ClassLocalStorage.getClassById(id);
        return JoinRequestsScreen(
          classId: id,
          className: classData?["name"] ?? "Class",
        );
      },
    ),
    GoRoute(
      path: '/instructor/announcements/:classId',
      name: 'instructor-announcements',
      builder: (_, state) => AnnouncementsScreen(classId: state.pathParameters['classId']!),
    ),
    GoRoute(path: '/instructor/session-details',name: 'session-details',builder: (context, state) {
    final session = state.extra as AttendanceSession; 
    return SessionDetailsScreen(session: session);
  },),
    // Student
    GoRoute(path: '/student/home', name: 'student-home', builder: (context, state) => const StudentHomeScreen()),
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (context, state) => const TimetableScreen(),),
    GoRoute(path: '/student/join-code', name: 'student-join-code', builder: (_, __) => const EnterJoinCodeScreen()),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (_, __) => const AttendanceQRScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (context, state) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/notifications', name: 'student-notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/student/class', name: 'student-class', builder: (context, state) => ClassDetailScreen(),),
    GoRoute(path: '/attendance-marked', name: 'attendance-marked', builder: (_, __) => const AttendanceMarkedScreen()),

    GoRoute(
      path: '/instructor/start-session/:classId',
      name: 'instructor-start-session',
      builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!),
    ),

    GoRoute(
      path: '/instructor/qr-display/:sessionId',
      name: 'instructor-qr-display',
      builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!),
    ),

    GoRoute(
      path: '/instructor/attendance-record',
      name: 'attendance-record',
      builder: (_, _) => const AttendanceRecordScreen(),
    ),
  ]
);
