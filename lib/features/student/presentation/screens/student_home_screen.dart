// features/student/presentation/screens/student_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/student_models.dart';
import '../widgets/class_list.dart';
import '../widgets/student_drawer.dart';
import '../widgets/join_class_dialog.dart';
import '../providers/student_providers.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final profileAsync = ref.watch(studentProfileProvider);
    final classesAsync = ref.watch(uiStudentClassesProvider);
    final hasUnread = ref.watch(hasUnreadNotificationsProvider);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const StudentDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studentProfileProvider);
          ref.invalidate(uiStudentClassesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 420,
                child: _buildBlueHeader(
                    context, ref, scaffoldKey, profileAsync, classesAsync, hasUnread),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'My Classes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E)),
                    ),
                    const SizedBox(height: 20),
                    classesAsync.when(
                      loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          )),
                      error: (e, _) => _ErrorCard(
                          message: e.toString(),
                          onRetry: () =>
                              ref.invalidate(uiStudentClassesProvider)),
                      data: (classes) => ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: classes.length,
                        itemBuilder: (context, index) {
                          final c = classes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClassCard(
                              classData: c,
                              onTap: () => context.pushNamed(
                                'student-class',
                                queryParameters: {'classId': c.id},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlueHeader(
      BuildContext context,
      WidgetRef ref,
      GlobalKey<ScaffoldState> key,
      AsyncValue profileAsync,
      AsyncValue<List<StudentClass>> classesAsync,
      bool hasUnread,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  profileAsync.when(
                    loading: () => const Text('Welcome back,',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    error: (_, _) => const Text('Welcome back,',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    data: (profile) => RichText(
                      text: TextSpan(
                        text: 'Welcome back,\n',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 18),
                        children: [
                          TextSpan(
                            text: profile.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _headerIcon(
                        Icons.notifications_none_outlined,
                        hasNotification: hasUnread,
                        onTap: () =>
                            context.pushNamed('student-notifications'),
                      ),
                      const SizedBox(width: 12),
                      _headerIcon(
                        Icons.menu,
                        onTap: () => key.currentState?.openEndDrawer(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Calculate stats from classes
              classesAsync.when(
                loading: () => const _StatsRowSkeleton(),
                error: (_, __) => const _StatsRowSkeleton(),
                data: (classes) => _buildStatsFromClasses(classes),
              ),
            ],
          ),
        ),
        _buildQuickActionsCard(context),
      ],
    );
  }

  // Calculate overall attendance from all classes
  Widget _buildStatsFromClasses(List<StudentClass> classes) {
    if (classes.isEmpty) {
      return _buildStatsRow('0%', '0', '0');
    }

    int totalPresent = 0;
    int totalSessions = 0;

    for (var classData in classes) {
      totalPresent += classData.presentSessions;
      totalSessions += classData.totalSessions;
    }

    double overallAttendance = totalSessions > 0
        ? (totalPresent / totalSessions) * 100
        : 0.0;

    return _buildStatsRow(
      '${overallAttendance.toStringAsFixed(0)}%',
      totalPresent.toString(),
      (totalSessions - totalPresent).toString(),
    );
  }

  Widget _headerIcon(IconData icon,
      {bool hasNotification = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.accentBlue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppTheme.surfaceColor, size: 28),
            if (hasNotification)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
      String attendance, String present, String absent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _statItem('Overall\nAttendance', attendance)),
        const SizedBox(width: 10),
        Expanded(child: _statItem('Present\nSessions', present)),
        const SizedBox(width: 10),
        Expanded(child: _statItem('Absent\nSessions', absent)),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Positioned(
      bottom: -25,
      left: 10,
      right: 10,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const JoinClassDialog(),
                      ),
                      child: _rectangularActionButton(
                        icon: Icons.add,
                        label: 'Join Class',
                        iconColor: AppTheme.primaryColor,
                        bgColor: const Color(0xFFE7EEFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          context.pushNamed('student-timetable'),
                      child: _rectangularActionButton(
                        icon: Icons.calendar_month,
                        label: 'Timetable',
                        iconColor: Colors.purple,
                        bgColor: const Color(0xFFF3EDF7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rectangularActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration:
      BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        3,
            (_) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(message, style: TextStyle(color: AppTheme.errorColor)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}