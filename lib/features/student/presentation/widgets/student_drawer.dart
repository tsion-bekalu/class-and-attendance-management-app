// features/student/presentation/widgets/student_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/student/presentation/widgets/logout_dialog.dart';
import '../../../../features/student/presentation/widgets/delete_dialog.dart';
import '../providers/student_providers.dart';

class StudentDrawer extends ConsumerWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(studentProfileProvider);

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            // Profile section
            profileAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const _DefaultProfile(),
              data: (profile) => Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        profile.studentId,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Text(
                        'Student',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _drawerItem(
              icon: Icons.calendar_today_outlined,
              label: 'Timetable',
              onTap: () => context.pushNamed('student-timetable'),
            ),
            const SizedBox(height: 10),
            _drawerItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                );
              },
            ),
            const SizedBox(height: 10),
            _drawerItem(
              icon: Icons.delete_outline,
              label: 'Delete Account',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const DeleteDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        label,
        style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

class _DefaultProfile extends StatelessWidget {
  const _DefaultProfile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: AppTheme.primaryColor,
          child: Text('S',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student',
                style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const Text('Student',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
