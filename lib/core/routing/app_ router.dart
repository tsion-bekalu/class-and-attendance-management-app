import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ============ PLACEHOLDER SCREENS (for compilation) ============
// Other team members will replace these with real screens

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Splash Screen')));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Login Screen')));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Register Screen')));
}

// Instructor Screens
class ClassListScreen extends StatelessWidget {
  const ClassListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Class List')));
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
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Edit Class: $classId')));
}

class JoinRequestsScreen extends StatelessWidget {
  final String classId;
  const JoinRequestsScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Join Requests for Class: $classId')));
}

class AnnouncementsScreen extends StatelessWidget {
  final String classId;
  const AnnouncementsScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Announcements for Class: $classId')));
}

// Attendance Screens
class StartSessionScreen extends StatelessWidget {
  final String classId;
  const StartSessionScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Start Session for Class: $classId')));
}

class QRDisplayScreen extends StatelessWidget {
  final String sessionId;
  const QRDisplayScreen({super.key, required this.sessionId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('QR Display for Session: $sessionId')));
}

class AttendanceRecordsScreen extends StatelessWidget {
  final String classId;
  const AttendanceRecordsScreen({super.key, required this.classId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Attendance Records for Class: $classId')));
}

class AttendanceSessionDetailScreen extends StatelessWidget {
  final String sessionId;
  const AttendanceSessionDetailScreen({super.key, required this.sessionId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Session Detail: $sessionId')));
}

// Student Screens
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Timetable')));
}

class EnterJoinCodeScreen extends StatelessWidget {
  const EnterJoinCodeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Enter Join Code')));
}

class JoinRequestStatusScreen extends StatelessWidget {
  const JoinRequestStatusScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Join Request Status')));
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

// ============ ROUTER CONFIGURATION ============

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Auth routes
    GoRoute(path: '/splash', name: 'splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', name: 'login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', name: 'register', builder: (_, __) => const RegisterScreen()),
    
    // Instructor - Class Management
    GoRoute(path: '/instructor/classes', name: 'instructor-classes', builder: (_, __) => const ClassListScreen()),
    GoRoute(path: '/instructor/create-class', name: 'instructor-create-class', builder: (_, __) => const CreateClassScreen()),
    GoRoute(path: '/instructor/edit-class/:classId', name: 'instructor-edit-class', builder: (_, state) => EditClassScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/join-requests/:classId', name: 'instructor-join-requests', builder: (_, state) => JoinRequestsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/announcements/:classId', name: 'instructor-announcements', builder: (_, state) => AnnouncementsScreen(classId: state.pathParameters['classId']!)),
    
    // Instructor - Attendance
    GoRoute(path: '/instructor/start-session/:classId', name: 'instructor-start-session', builder: (_, state) => StartSessionScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/qr-display/:sessionId', name: 'instructor-qr-display', builder: (_, state) => QRDisplayScreen(sessionId: state.pathParameters['sessionId']!)),
    GoRoute(path: '/instructor/attendance-records/:classId', name: 'instructor-attendance-records', builder: (_, state) => AttendanceRecordsScreen(classId: state.pathParameters['classId']!)),
    GoRoute(path: '/instructor/session-detail/:sessionId', name: 'instructor-session-detail', builder: (_, state) => AttendanceSessionDetailScreen(sessionId: state.pathParameters['sessionId']!)),
    
    // Student routes
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (_, __) => const TimetableScreen()),
    GoRoute(path: '/student/join-code', name: 'student-join-code', builder: (_, __) => const EnterJoinCodeScreen()),
    GoRoute(path: '/student/request-status', name: 'student-request-status', builder: (_, __) => const JoinRequestStatusScreen()),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (_, __) => const StudentAttendanceScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (_, __) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/announcements', name: 'student-announcements', builder: (_, __) => const StudentAnnouncementsScreen()),
  ],
);