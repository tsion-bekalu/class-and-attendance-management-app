// features/student/presentation/screens/attendance_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/student_models.dart';
import '../widgets/attendance_card.dart';
import '../providers/student_providers.dart';

class AttendanceHistoryScreen extends ConsumerWidget {
  final String classId;

  const AttendanceHistoryScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(attendanceHistoryProvider(classId));
    final classAsync = ref.watch(uiStudentClassesProvider);

    // Get class name from the UI provider
    String className = 'Class';
    bool isHardcodedClass = false;

    classAsync.whenData((classes) {
      final found = classes.firstWhere(
            (c) => c.id == classId,
        orElse: () => StudentClass(
          id: '',
          name: 'Class',
          courseCode: '',
          instructorName: '',
          attendancePercentage: 0,
          presentSessions: 0,
          totalSessions: 0,
          schedule: '',
          instructorId: '',
          roomNumber: 'TBD',
        ),
      );
      className = found.name;

      isHardcodedClass = (classId == 'CS301' || classId == 'CS305' || classId == 'CS308');
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, className),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(attendanceHistoryProvider(classId));
                ref.invalidate(uiStudentClassesProvider);
              },
              child: historyAsync.when(
                loading: () => _buildContent(context, classId, className, isHardcodedClass),
                error: (e, _) => _buildContent(context, classId, className, isHardcodedClass),
                data: (entries) {
                  if (entries.isEmpty) {
                    return _buildContent(context, classId, className, isHardcodedClass);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    itemCount: entries.length,
                    itemBuilder: (context, index) =>
                        AttendanceHistoryCard(entry: entries[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, String classId, String className, bool isHardcodedClass) {
    // For newly joined classes (not CS301, CS305, CS308), show empty state
    if (!isHardcodedClass) {
      return _buildEmptyHistory(className);
    }

    return _buildHardcodedHistory(classId, className);
  }

  Widget _buildHeader(BuildContext context, String className) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  className,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Empty state for newly joined classes
  Widget _buildEmptyHistory(String className) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_edu,
                size: 64,
                color: AppTheme.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Attendance Records Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t attended any sessions for\n"$className" yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline,
                      size: 20,
                      color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Attendance history will appear here once you start attending classes',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHardcodedHistory(String classId, String className) {

    final historyEntries = _getHardcodedAttendanceHistory(classId, className);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: historyEntries.length,
      itemBuilder: (context, index) => _buildHardcodedAttendanceCard(historyEntries[index]),
    );
  }

  List<Map<String, dynamic>> _getHardcodedAttendanceHistory(String classId, String className) {
    // For CS301 - Data Structures & Algorithms
    if (classId == 'CS301') {
      return [
        {
          'title': 'Binary Search Trees',
          'date': 'Apr 11, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Graph Algorithms',
          'date': 'Apr 9, 2026',
          'time': '10:00 AM',
          'status': 'Absent',
          'statusColor': Colors.red,
        },
        {
          'title': 'Dynamic Programming',
          'date': 'Apr 7, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Sorting Algorithms',
          'date': 'Apr 4, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Linked Lists',
          'date': 'Apr 2, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Stacks & Queues',
          'date': 'Mar 30, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Trees & Binary Trees',
          'date': 'Mar 28, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Hash Tables',
          'date': 'Mar 25, 2026',
          'time': '10:00 AM',
          'status': 'Absent',
          'statusColor': Colors.red,
        },
      ];
    }

    // For CS305 - Database Management Systems
    else if (classId == 'CS305') {
      return [
        {
          'title': 'SQL Queries',
          'date': 'Apr 12, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Database Normalization',
          'date': 'Apr 10, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'ER Diagrams',
          'date': 'Apr 8, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Transactions & ACID',
          'date': 'Apr 5, 2026',
          'time': '10:00 AM',
          'status': 'Absent',
          'statusColor': Colors.red,
        },
        {
          'title': 'Indexing',
          'date': 'Apr 3, 2026',
          'time': '10:00 AM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
      ];
    }

    // For CS308 - Web Development
    else if (classId == 'CS308') {
      return [
        {
          'title': 'React Hooks',
          'date': 'Apr 13, 2026',
          'time': '3:30 PM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'API Integration',
          'date': 'Apr 10, 2026',
          'time': '3:30 PM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'State Management',
          'date': 'Apr 8, 2026',
          'time': '3:30 PM',
          'status': 'Present',
          'statusColor': Colors.green,
        },
        {
          'title': 'Routing',
          'date': 'Apr 5, 2026',
          'time': '3:30 PM',
          'status': 'Absent',
          'statusColor': Colors.red,
        },
      ];
    }

    // Return empty list for any other class (newly joined ones)
    return [];
  }

  Widget _buildHardcodedAttendanceCard(Map<String, dynamic> entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            entry['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          // Date and Time row
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 14,
                  color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                entry['date'],
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time,
                  size: 14,
                  color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                entry['time'],
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: entry['status'] == 'Present'
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: entry['status'] == 'Present'
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry['status'] == 'Present'
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 16,
                  color: entry['statusColor'],
                ),
                const SizedBox(width: 6),
                Text(
                  entry['status'],
                  style: TextStyle(
                    color: entry['statusColor'],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}