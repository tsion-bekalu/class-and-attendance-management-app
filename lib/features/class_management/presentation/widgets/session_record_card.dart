import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SessionRecordCard extends StatelessWidget {
  final String date;
  final String time;
  final String attendanceCount;
  final String percentage;
  final VoidCallback onTap;

  const SessionRecordCard({
    super.key,
    required this.date,
    required this.time,
    required this.attendanceCount,
    required this.percentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column( 
            children: [
            Row(
            children: [
              // Icon Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(time, style: const TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 12),
                    
                  ],
                ),
              ),
              
              // Percentage & Arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.chevron_right, color: Colors.black26),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255,220, 252, 231),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      percentage,
                      style: const TextStyle(
                        color: Color.fromARGB(255,0, 130, 54),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
                      children: [
                        const Icon(Icons.people_outline, size: 18, color: AppTheme.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          "$attendanceCount attended",
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
            ]
          )
        ),
      ),
    );
  }
}