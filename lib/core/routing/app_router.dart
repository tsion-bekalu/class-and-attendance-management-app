import 'package:app/features/student/presentation/screens/attendance_analog_screen.dart';
import 'package:go_router/go_router.dart';

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
import 'package:app/features/class_management/domain/entities/session_record.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/instructor/dashboard',
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
      path: '/instructor/announcements',
      name: 'instructor-announcements',
      builder: (context, state) => AnnouncementsScreen(),
    ),
    GoRoute(path: '/instructor/session-details',name: 'session-details',builder: (context, state) {
    final session = state.extra as AttendanceSession; 
    return SessionDetailsScreen(session: session);
  },),
    // Student
    GoRoute(path: '/student/home', name: 'student-home', builder: (context, state) => const StudentHomeScreen()),
    GoRoute(path: '/student/timetable', name: 'student-timetable', builder: (context, state) => const TimetableScreen(),),
    GoRoute(path: '/student/attendance', name: 'student-attendance', builder: (context, state) => const AttendanceScanScreen()),
    GoRoute(path: '/student/attendance-history', name: 'student-attendance-history', builder: (context, state) => const AttendanceHistoryScreen()),
    GoRoute(path: '/student/notifications', name: 'student-notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/student/class', name: 'student-class', builder: (context, state) => ClassDetailScreen(),),
    GoRoute(path: '/attendance-marked', name: 'attendance-marked', builder: (_, __) => const AttendanceMarkedScreen()),

  ]
);
