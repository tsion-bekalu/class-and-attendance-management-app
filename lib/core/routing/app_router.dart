import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/auth/presentation/screens/splash.dart';
import 'package:app/features/auth/presentation/screens/role_selection.dart';
import 'package:app/features/auth/presentation/screens/login.dart';
import 'package:app/features/auth/presentation/screens/register.dart';


// ignore_for_file: unnecessary_underscores
class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Classes')));
}
class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Create Class')));
}
class EditClassScreen extends StatelessWidget {
  final String classId;
  const EditClassScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Edit Class $classId')));
}
class JoinRequestsScreen extends StatelessWidget {
  final String classId;
  const JoinRequestsScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Join Requests for $classId')));
}
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
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Timetable')));
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
class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Attendance History')));
}
class StudentAnnouncementsScreen extends StatelessWidget {
  const StudentAnnouncementsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Student Announcements')));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', name: 'splash', builder: (context,state) => const SplashScreen()),
    GoRoute(path: '/role_selection', name: 'role_selection', builder: (context,state) => const RoleSelectionScreen()), 
    GoRoute(path: '/login', name: 'login', builder: (context,state) => LoginScreen(role: state.extra as String)),
    GoRoute(path: '/register', name: 'register', builder: (context,state) => RegisterScreen(role: state.extra as String)),
   
    // Instructor
    GoRoute(path: '/instructor/classes', name: 'instructor-classes', builder: (_, __) => const ClassListScreen()),
    GoRoute(path: '/instructor/create-class', name: 'instructor-create-class', builder: (_, __) => const CreateClassScreen()),
    GoRoute(path: '/instructor/edit-class/:classId', name: 'instructor-edit-class', builder: (_, state) => EditClassScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/join-requests/:classId', name: 'instructor-join-requests', builder: (_, state) => JoinRequestsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/announcements/:classId', name: 'instructor-announcements', builder: (_, state) => AnnouncementsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/start-session/:classId', name: 'instructor-start-session', builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/qr-display/:sessionId', name: 'instructor-qr-display', builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!)),
    GoRoute(path: '/instructor/timetable', name: 'instructor-timetable', builder: (_, __) => const TimetableScreen()),
    // Student
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (_, __) => const TimetableScreen()),
    GoRoute(path: '/student/join-code', name: 'student-join-code', builder: (_, __) => const EnterJoinCodeScreen()),
    GoRoute(path: '/student/request-status', name: 'student-request-status', builder: (_, __) => const JoinRequestStatusScreen()),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (_, __) => const StudentAttendanceScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (_, __) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/announcements', name: 'student-announcements', builder: (_, __) => const StudentAnnouncementsScreen()),
  ],
);
