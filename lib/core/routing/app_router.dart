import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:app/features/class_management/presentation/screens/class_details_screen.dart';
import 'package:app/features/class_management/presentation/screens/dashboard_screen.dart';
import 'package:app/features/class_management/presentation/screens/create_class_screen.dart';
import 'package:app/features/class_management/data/class_local_storage.dart';
import 'package:app/features/class_management/presentation/screens/join_requests_screen.dart';
import 'package:app/features/auth/presentation/screens/splash.dart';
import 'package:app/features/auth/presentation/screens/role_selection.dart';
import 'package:app/features/auth/presentation/screens/login.dart';
import 'package:app/features/auth/presentation/screens/register.dart';
import 'package:app/features/student/presentation/screens/notification_screen.dart';
import 'package:app/features/student/presentation/screens/student_home_screen.dart';
import 'package:app/features/student/presentation/screens/timetable_screen.dart';
import 'package:app/features/student/presentation/screens/attendace_history_screen.dart';
import 'package:app/features/student/presentation/screens/class_detail_screen.dart';




class AnnouncementsScreen extends StatelessWidget {
  final String classId;
  const AnnouncementsScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Announcements $classId')));
}
class StartSessionScreen extends StatelessWidget {
  final String classId;
  const StartSessionScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Start Session $classId')));
}
class QRDisplayScreen extends StatelessWidget {
  final String sessionId;
  const QRDisplayScreen({super.key, required this.sessionId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('QR $sessionId')));
}

class EnterJoinCodeScreen extends StatelessWidget {
  const EnterJoinCodeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Join Code')));
}
class JoinRequestStatusScreen extends StatelessWidget {
  const JoinRequestStatusScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Request Status')));
}
class StudentAttendanceScreen extends StatelessWidget {
  const StudentAttendanceScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Student Attendance')));
}


final GoRouter appRouter = GoRouter(
  initialLocation: '/instructor/dashboard',
  routes: [
    // Instructor
    GoRoute(path: '/splash', name: 'splash', builder: (context,state) => const SplashScreen()),
    GoRoute(path: '/role_selection', name: 'role_selection', builder: (context,state) => const RoleSelectionScreen()), 
    GoRoute(path: '/login', name: 'login', builder: (context,state) => LoginScreen(role: state.extra as String)),
    GoRoute(path: '/register', name: 'register', builder: (context,state) => RegisterScreen(role: state.extra as String)),
    GoRoute(path: '/instructor/dashboard', name: 'instructor-dashboard', builder: (_,_) => const InstructorDashboardScreen()),
    GoRoute(path: '/instructor/create-class', name: 'create-class', builder: (_,_) => const CreateClassScreen()),
    GoRoute(path: '/instructor/class-details/:classId', name: 'class-details', builder: (_,state){
      final id = state.pathParameters['classId']!; 
      return ClassDetailsScreen(classId: id);} ),
    GoRoute(path: '/instructor/edit-class/:classId', name: 'instructor-edit-class', builder: (_, state) => EditClassScreen(classId: state.pathParameters['classId']!)),
    GoRoute(
  path: '/instructor/class-details/:id/join-requests',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final classData = ClassLocalStorage.getClassById(id);
    return JoinRequestsScreen(
      classId: id,
      className: classData?["name"] ?? "Class",
    );
  },
),

    GoRoute(path: '/instructor/announcements/:classId', name: 'instructor-announcements', builder: (_, state) => AnnouncementsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/start-session/:classId', name: 'instructor-start-session', builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/qr-display/:sessionId', name: 'instructor-qr-display', builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!)),
    GoRoute(path: '/instructor/timetable', name: 'instructor-timetable', builder: (_, _) => const TimetableScreen()),
    // Student
    GoRoute(path: '/student/home', name: 'student-home', builder: (context, state) => const StudentHomeScreen()),
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (context, state) => const TimetableScreen(),),
    GoRoute(path: '/student/join-code', name: 'student-join-code', builder: (_, _) => const EnterJoinCodeScreen()),
    GoRoute(path: '/student/request-status', name: 'student-request-status', builder: (_, _) => const JoinRequestStatusScreen()),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (_, _) => const StudentAttendanceScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (context, state) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/notifications', name: 'student-notifications', builder: (_, _) => const NotificationsScreen()),
    GoRoute(path: '/student/class', name: 'student-class', builder: (context, state) => ClassDetailScreen(),),
    ],
);
