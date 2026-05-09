import 'package:flutter/material.dart';
import '../../../../core/routing/theme/app_theme.dart';
import 'package:app/core/models/time_table_entry.dart';


class TimetableCard extends StatelessWidget {
  final TimetableEntry entry;
  final VoidCallback? onTap;

  const TimetableCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: entry.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16, 
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      // Duration Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.duration, 
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    entry.courseCode, 
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(entry.time, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(entry.location, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}