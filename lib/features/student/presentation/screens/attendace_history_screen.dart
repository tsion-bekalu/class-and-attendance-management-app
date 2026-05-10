import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:app/features/student/presentation/widgets/attendance_card.dart';
import 'package:app/features/student/data/mock_attendance.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  //attendance card
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              itemCount: attendanceHistoryMock.length,
              itemBuilder: (context, index) {
                return AttendanceHistoryCard(entry: attendanceHistoryMock[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

//blue header
Widget _buildHeader(BuildContext context) {
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
            color: Colors.white.withValues(alpha:0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Attendance History",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Text(
              "Computer Science",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
        )
      ],
    ),
  );
}
