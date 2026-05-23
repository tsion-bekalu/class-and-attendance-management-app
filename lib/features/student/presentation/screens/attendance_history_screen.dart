// features/student/presentation/screens/attendance_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/attendance_card.dart';
import '../providers/student_providers.dart';

class AttendanceHistoryScreen extends ConsumerWidget {
  final String classId;

  const AttendanceHistoryScreen({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(attendanceHistoryProvider(classId));
    final classAsync = ref.watch(classDetailProvider(classId));

    final className = classAsync.whenOrNull(data: (c) => c.name) ?? 'Class';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context, className),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(attendanceHistoryProvider(classId)),
              child: historyAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $e'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(attendanceHistoryProvider(classId)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (entries) => entries.isEmpty
                    ? const Center(
                        child: Text('No attendance records yet.',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        itemCount: entries.length,
                        itemBuilder: (context, index) =>
                            AttendanceHistoryCard(entry: entries[index]),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
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
}
