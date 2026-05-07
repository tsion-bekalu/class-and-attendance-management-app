import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/routing/theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppTheme.primaryColor, 
              child: Text('H', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            accountName: const Text('Mr.Tilahun', 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text('Instructor', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Timetable'),
            onPressed: () {
    
    Navigator.pop(context); 
    
    
    context.push('/timetable'); 
  },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => _showDialog(context, isDelete: false),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Delete Account', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => _showDialog(context, isDelete: true),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, {required bool isDelete}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isDelete ? 'Delete Account?' : 'Logout?'),
        content: Text(isDelete 
          ? 'This action cannot be undone. All account data will be permanently deleted.' 
          : 'Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDelete ? Colors.red : AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context.go('/login'),
            child: Text(isDelete ? 'Delete' : 'Log Out', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}