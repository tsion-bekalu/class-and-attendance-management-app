import 'package:flutter/material.dart';
import 'package:app/core/theme/app_theme.dart';
import '../../data/attendance_entry.dart';
import '../../domain/entities/attendance_entry.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/session_record.dart';


class StartAttendanceScreen extends StatelessWidget {
  const StartAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildQRCodeCard(),
                  const SizedBox(height: 20),
                  _buildLiveAttendanceList(),
                  const SizedBox(height: 30),
                  _buildEndSessionButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            color: Colors.white.withValues(alpha:0.2),
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
              "Attendance Session",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Widget _buildQRCodeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF), // Very light blue for QR background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/qr.png', // Replace with your actual path
              height: 200,
              width: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2, size: 200, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Session Code", style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 4),
          const Text(
            "1NMQQCB4",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          const Text(
            "Students can scan this QR code or enter the code manually to mark attendance",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAttendanceList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Live Attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Color.fromARGB(255, 56, 205, 56)),
                  const SizedBox(width: 6),
                  Text("${mockLiveAttendance.length} marked", style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...mockLiveAttendance.map((student) => _buildStudentTile(student)),
        ],
      ),
    );
  }

  Widget _buildStudentTile(LiveAttendanceEntry student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF5), // Soft green background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color.fromARGB(255, 28, 161, 28), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              student.studentName,
              style: const TextStyle(fontWeight: FontWeight.w400, color: AppTheme.textPrimary),
            ),
          ),
          Text(
            student.timestamp,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEndSessionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () {
  final session = AttendanceSession(
    date: "May 10, 2026",
    time: "10:00 AM",
    attendanceCount: "${mockLiveAttendance.length}",
    percentage: "80%",
    attendees: mockLiveAttendance.map((student) {
      return SessionAttendee(
        name: student.studentName,
        isPresent: true,
      );
    }).toList(),
  );

  context.replaceNamed(
    'session-details',
    extra: session,
  );
},
        icon: const Icon(Icons.stop_circle_outlined),
        label: const Text("End Session", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}