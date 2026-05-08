import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/student/presentation/screens/notification_screen.dart';
import 'package:app/features/student/presentation/screens/student_home_screen.dart';
import 'package:app/features/student/presentation/screens/timetable_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Splash')));
}
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Login')));
}
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Register')));
}
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
  initialLocation: '/student/home',
  routes: [
    GoRoute(
      path: '/student/home', 
      name: 'student-home', 
      builder: (context, state) => const StudentHomeScreen()
    ),
    GoRoute(path: '/splash', name: 'splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', name: 'login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', name: 'register', builder: (_, __) => const RegisterScreen()),
    // Instructor
    GoRoute(path: '/instructor/classes', name: 'instructor-classes', builder: (_, __) => const ClassListScreen()),
    GoRoute(path: '/instructor/create-class', name: 'instructor-create-class', builder: (_, __) => const CreateClassScreen()),
    GoRoute(path: '/instructor/edit-class/:classId', name: 'instructor-edit-class', builder: (_, state) => EditClassScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/join-requests/:classId', name: 'instructor-join-requests', builder: (_, state) => JoinRequestsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/announcements/:classId', name: 'instructor-announcements', builder: (_, state) => AnnouncementsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/start-session/:classId', name: 'instructor-start-session', builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/qr-display/:sessionId', name: 'instructor-qr-display', builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!)),
    // Student
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (context, state) => const TimetableScreen(),),
    GoRoute(path: '/student/join-code', name: 'student-join-code', builder: (_, __) => const EnterJoinCodeScreen()),
    GoRoute(path: '/student/request-status', name: 'student-request-status', builder: (_, __) => const JoinRequestStatusScreen()),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (_, __) => const StudentAttendanceScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (_, __) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/announcements', name: 'student-announcements', builder: (_, __) => const StudentAnnouncementsScreen()),
    GoRoute(path: '/student/notifications', name: 'student-notifications', builder: (_, __) => const NotificationsScreen()),
  ],

);
