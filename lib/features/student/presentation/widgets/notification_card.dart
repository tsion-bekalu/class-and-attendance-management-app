// features/student/presentation/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/student/domain/models/student_models.dart';

// Style map keyed by NotificationType
final _styleMap = {
  NotificationType.attendance: {
    'bg': const Color(0xFFE8F0FE),
    'icon': AppTheme.primaryColor,
    'data': Icons.fact_check_outlined,
  },
  NotificationType.announcement: {
    'bg': const Color(0xFFFFF3E0),
    'icon': Colors.orange,
    'data': Icons.campaign_outlined,
  },
  NotificationType.reminder: {
    'bg': const Color(0xFFE8F5E9),
    'icon': Colors.green,
    'data': Icons.alarm_outlined,
  },
  NotificationType.general: {
    'bg': const Color(0xFFF3E5F5),
    'icon': Colors.purple,
    'data': Icons.notifications_outlined,
  },
};

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final style = _styleMap[notification.type]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 10),
      decoration: BoxDecoration(
        color: notification.isUnread
            ? AppTheme.surfaceColor
            : AppTheme.surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.15), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: style['bg'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(style['data'] as IconData,
                  color: style['icon'] as Color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeader(),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.title,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.description,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, height: 1.4, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notification.courseName,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          notification.courseCode,
          style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        if (notification.isUnread)
          Container(
            margin: const EdgeInsets.only(left: 6),
            height: 7,
            width: 7,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
