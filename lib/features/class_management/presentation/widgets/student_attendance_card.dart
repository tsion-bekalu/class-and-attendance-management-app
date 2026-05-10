import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/student_attendance_model.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentAttendance student;

  const StudentAttendanceCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    // Determine badge color based on performance
    final double percentage = double.parse(student.overallPercentage.replaceAll('%', ''));
    final Color badgeBg = percentage >= 75 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final Color badgeText = percentage >= 75 ? const Color.fromARGB(255, 46, 180, 52) : const Color(0xFFC62828);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE3F2FD),
                child: const Icon(Icons.person_outline, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                    Text(student.email, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                child: Text(student.overallPercentage, style: TextStyle(color: badgeText, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox("Present", student.presentRatio, const Color(0xFFF1F8F1), const Color.fromARGB(255, 46, 180, 52)),
              const SizedBox(width: 12),
              _buildStatBox("Absent", student.absentRatio, const Color(0xFFFFEBEE), const Color(0xFFC62828)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}