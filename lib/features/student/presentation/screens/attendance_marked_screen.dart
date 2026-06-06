// features/student/presentation/screens/attendance_marked_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/student_providers.dart';

class AttendanceMarkedScreen extends ConsumerWidget {
  /// Passed as query params from the submission screen.
  final bool isPresent;
  final String className;
  final String sessionTime;
  final String classId;

  const AttendanceMarkedScreen({
    super.key,
    required this.isPresent,
    required this.className,
    required this.sessionTime,
    required this.classId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPresent
                      ? AppTheme.successColor.withOpacity(0.12)
                      : AppTheme.errorColor.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  isPresent ? Icons.check_circle_outline : Icons.cancel_outlined,
                  size: 72,
                  color: isPresent ? AppTheme.successColor : AppTheme.errorColor,
                ),
              ),
              const SizedBox(height: 40),

              Text(
                isPresent ? 'Attendance Marked!' : 'Marked as Absent',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 12),

              if (className.isNotEmpty)
                Text(
                  className,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (sessionTime.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  sessionTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black45),
                ),
              ],
              const SizedBox(height: 48),

              SizedBox(
                width: 140,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to class detail screen
                    context.pushNamed(
                      'student-class',
                      queryParameters: {'classId': classId},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Done',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}