import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/theme/app_theme.dart';
import '../widgets/class_list.dart'; 
import '../widgets/student_drawer.dart'; 
import '../widgets/join_class_dialog.dart';
import 'package:app/features/student/data/mock_classes.dart';
import 'package:app/features/student/data/mock_notifications.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  // Mock Data
  
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      // Drawer is on the right, so we use endDrawer
      endDrawer: const StudentDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
  height: 420,
  child: _buildBlueHeader(context, scaffoldKey),
),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "My Classes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mockClasses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClassCard(
                          classData: mockClasses[index],
                          onTap: () { context.pushNamed('student-class');},
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueHeader(BuildContext context, GlobalKey<ScaffoldState> key) {
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
                  RichText(
                    text: const TextSpan(
                      text: "Welcome back,\n",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      children: [
                        TextSpan(
                          text: "B", // Replaced 'b' with placeholder
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Notification Icon with dynamic unread logic
                      _headerIcon(
                        Icons.notifications_none_outlined, 
                        hasNotification: mockNotifications.any((n) => n.isUnread),
                        onTap: ()  {
                          context.pushNamed('student-notifications');}
                      ),
                      const SizedBox(width: 12),
                      // Menu Icon to open the Right Drawer
                      _headerIcon(
                        Icons.menu,
                        onTap: () => key.currentState?.openEndDrawer(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildStatsRow(),
            ],
          ),
        ),
        _buildQuickActionsCard(context),
      ],
    );
  }

  Widget _headerIcon(IconData icon, {bool hasNotification = false, VoidCallback? onTap}) {
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

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _statItem("Overall\nAttendance", "85%")),
        const SizedBox(width: 10), // This adds the gap you wanted!
        Expanded(child: _statItem("Present\nSessions", "34")),
        const SizedBox(width: 10), // Gap between middle and right
        Expanded(child: _statItem("Absent\nSessions", "6")),
      ],
    );
  }

  Widget _statItem(String label, String value) {
  return Container(
    // Added a fixed width so all three boxes are the same size
    width: 105, 
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(
      // Only using white with low opacity for a subtle "glass" feel
      color: Colors.white.withOpacity(0.1), 
      borderRadius: BorderRadius.circular(16),
      // A very thin border helps define the edges on dark backgrounds
      border: Border.all(
        color: Colors.white.withOpacity(0.05),
        width: 1,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7), // Slightly dimmed text
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
              const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () { showDialog(
                        context: context,
                        builder: (_) => const JoinClassDialog(),
                      );
                      },
                      child: _rectangularActionButton(
                        icon: Icons.add,
                        label: "Join Class",
                        iconColor: AppTheme.primaryColor,
                        bgColor: const Color(0xFFE7EEFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => context.pushNamed('student-timetable'),
                      child: _rectangularActionButton(
                        icon: Icons.calendar_month,
                        label: "Timetable",
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

  Widget _rectangularActionButton({required IconData icon, required String label, required Color iconColor, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

