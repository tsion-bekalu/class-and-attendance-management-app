// features/student/presentation/widgets/class_list.dart
import 'package:flutter/material.dart';
import 'package:app/features/student/domain/models/student_models.dart';
import '../../../../core/theme/app_theme.dart';

class ClassCard extends StatelessWidget {
  final StudentClass classData;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color accent
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${classData.courseCode} • ${classData.instructorName}',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          classData.schedule,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Attendance badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _attendanceColor(classData.attendancePercentage)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${classData.attendancePercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color:
                        _attendanceColor(classData.attendancePercentage),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _attendanceColor(double pct) {
    if (pct >= 75) return AppTheme.successColor;
    if (pct >= 50) return Colors.orange;
    return AppTheme.errorColor;
  }
}
