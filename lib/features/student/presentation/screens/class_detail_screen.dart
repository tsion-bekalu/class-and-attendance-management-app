// features/student/presentation/screens/class_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/student_drawer.dart';
import '../providers/student_providers.dart';
import 'package:app/features/student/domain/models/student_models.dart';

class ClassDetailScreen extends ConsumerWidget {
  final String classId;

   ClassDetailScreen({super.key, required this.classId});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final uiClasses = ref.watch(uiStudentClassesProvider);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const StudentDrawer(),
      backgroundColor: AppTheme.backgroundColor,
      body: uiClasses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, ref, e.toString()),
        data: (classes) {
          // Find the class in the UI list
          final classData = classes.firstWhere(
                (c) => c.id == classId,
            orElse: () => throw Exception('Class not found'),
          );

          final announcementsAsync = ref.watch(announcementsProvider(classId));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(announcementsProvider(classId));
              ref.invalidate(uiStudentClassesProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(context, classData),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildScheduleSection(classData),
                        const SizedBox(height: 24),
                        _buildActionButtons(context, classId),
                        const SizedBox(height: 32),
                        const Text(
                          'Recent Announcements',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        announcementsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => _buildHardcodedAnnouncements(),
                          data: (announcements) {
                            if (announcements.isEmpty) {
                              return _buildHardcodedAnnouncements();
                            }
                            return _buildAnnouncementList(announcements);
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Class not found: $message'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.pushReplacementNamed('student-home'),
            child: const Text('Go Back Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StudentClass classData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circularIconButton(
                  Icons.arrow_back, () => context.pushNamed('student-home')),
              _circularIconButton(
                  Icons.menu, () => _scaffoldKey.currentState?.openEndDrawer()),
            ],
          ),
          const SizedBox(height: 24),
          Text(classData.courseCode,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(
            classData.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_outline, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  classData.instructorName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _headerStatCard('Attendance',
                  '${classData.attendancePercentage.toStringAsFixed(0)}%'),
              const SizedBox(width: 16),
              _headerStatCard('Sessions',
                  '${classData.presentSessions}/${classData.totalSessions}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circularIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, color: Colors.white, size: 20), onPressed: onTap),
    );
  }

  Widget _headerStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(StudentClass classData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Class Schedule',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppTheme.accentBlue,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    classData.schedule,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String classId) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            Icons.qr_code_scanner,
            'Start Attendance',
                () => context.pushNamed('student-attendance',
                queryParameters: {'classId': classId}),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _actionCard(
            Icons.bar_chart_rounded,
            'Attendance History',
                () => context.pushNamed('student-attendance-history',
                queryParameters: {'classId': classId}),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppTheme.accentBlue, shape: BoxShape.circle),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildHardcodedAnnouncements() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Class Cancelled - Monday',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                  'Please note that Monday\'s class has been cancelled due to a faculty meeting. We will resume on Wednesday.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppTheme.textSecondary, height: 1.4)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  const Text('2026-04-10 2:30 PM',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assignment Due Date Extended',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text(
                  'The deadline for Assignment 3 has been extended to April 20th. Please submit your work by then.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppTheme.textSecondary, height: 1.4)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  const Text('2026-04-10 10:30 AM',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementList(List<Announcement> announcements) {
    if (announcements.isEmpty) {
      return _buildHardcodedAnnouncements();
    }
    return Column(
      children: announcements
          .map((a) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(a.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppTheme.textSecondary, height: 1.4)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(a.dateTime,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ],
        ),
      ))
          .toList(),
    );
  }
}