import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/session_record_card.dart';
import '../../domain/entities/session_record.dart';
import '../../data/mock_attendance_data.dart';
import '../widgets/student_attendance_card.dart';
import '../../data/mock_student_data.dart';


class AttendanceRecordScreen extends StatefulWidget {
  const AttendanceRecordScreen({super.key});

  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreen();
}

class _AttendanceRecordScreen extends State<AttendanceRecordScreen> {
  // 0 = Sessions Tab, 1 = Students Tab
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildTabToggle(),
          const SizedBox(height: 20),
          Expanded(
            // Logic to switch between views
            child: _selectedTabIndex == 0 
                ? _buildSessionsView() 
                : _buildStudentsView(),
          ),
        ],
      ),
    );
  }

  // Blue Header section with back button and course info
 Widget _buildHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Attendance Records",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Computer Science",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  // The Sessions/Students pill toggle
  Widget _buildTabToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _toggleButton("Sessions", index: 0),
          _toggleButton("Students", index: 1),
        ],
      ),
    );
  }

  Widget _toggleButton(String title, {required int index}) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // The list of all sessions using the mock data list
  Widget _buildSessionsView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: mockAttendanceSessions.length,
      itemBuilder: (context, index) {
        final session = mockAttendanceSessions[index];
        
        // Wrap first item with "All Sessions" header
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "All Sessions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(session),
            ],
          );
        }
        
        return _buildCard(session);
      },
    );
  }

  Widget _buildCard(AttendanceSession session) {
    return SessionRecordCard(
      date: session.date,
      time: session.time,
      attendanceCount: session.attendanceCount,
      percentage: session.percentage,
      onTap: () {context.pushNamed('session-details', extra: session);
      },
    );
  }

  // Placeholder for the Students tab
  Widget _buildStudentsView() {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: mockStudentAttendance.length,
    itemBuilder: (context, index) {
      return StudentAttendanceCard(student: mockStudentAttendance[index]);
    },
  );
}
}