import 'package:flutter/material.dart';
import 'package:app/core/routing/theme/app_theme.dart';
import 'package:app/features/auth/domain/models/course_model.dart';
import 'package:app/features/auth/presentation/widgets/side_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF1A60FF),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Welcome back,\nMr.Tilahun', 
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatCard('Total Classes', '2', Icons.book_outlined),
                    const SizedBox(width: 16),
                    _buildStatCard('Students', '77', Icons.people_outline),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildQuickAction('New Class', Icons.add, Colors.blue.shade50, Colors.blue),
                    const SizedBox(width: 16),
                    _buildQuickAction('Timetable', Icons.calendar_today, Colors.purple.shade50, Colors.purple),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('My Classes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),

                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mockCourses.length, 
                  itemBuilder: (context, index) {
                    final course =mockCourses[index];
                    return _buildClassCard(course);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha:0.2), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color bg, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildClassCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (course.isActive)
                  const Chip(
                    label: Text('active', style: TextStyle(fontSize: 10, color: Colors.green)), 
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
              ],
            ),
            Text('Code: ${course.code}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(course.schedule, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${course.studentCount}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            if (course.hasPendingRequests) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.error_outline, size: 14, color: Colors.orange),
                    SizedBox(width: 8),
                    const Text('3 pending join requests', style: TextStyle(color: Colors.orange, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}