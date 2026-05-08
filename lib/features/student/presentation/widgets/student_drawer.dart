import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/theme/app_theme.dart';
import '../../../../features/student/presentation/widgets/logout_dialog.dart';
import '../../../../features/student/presentation/widgets/delete_dialog.dart';


class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Custom Profile Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text("H", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mr.B",
                      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text("Student", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            _drawerItem(
              icon: Icons.calendar_today_outlined, 
              label: 'Timetable', 
              onTap: () => context.pushNamed('student-timetable')
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
                  builder: (context) => const LogoutDialog(),
                );
              }),
            const SizedBox(height: 10),
            _drawerItem(
              icon: Icons.delete_outline, 
              label: 'Delete Account', 
              color: Colors.red,
              onTap: () {
                Navigator.pop(context); 
                showDialog(
                  context: context,
                  builder: (context) => const DeleteDialog(),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String label, Color color = Colors.black87, required VoidCallback onTap}) {
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