import 'package:flutter/material.dart';
import 'package:app/core/routing/theme/app_theme.dart';

// --- MODELS ---
// Usually, these should be in their own file (e.g., notification_model.dart)
enum NotificationType { announcement, alert, reminder }

class NotificationModel {
  final String id;
  final String courseCode;
  final String title;
  final String description;
  final String courseName;
  final String timeAgo;
  final NotificationType type;
  final bool isUnread;

  NotificationModel({
    required this.id,
    required this.courseCode,
    required this.title,
    required this.description,
    required this.courseName,
    required this.timeAgo,
    required this.type,
    this.isUnread = false,
  });
}

// Mock Data

final List<NotificationModel> mockNotifications = [

  NotificationModel(

    id: '1',

    courseCode: 'CS301',

    title: 'Assignment 3 Due Date Extended',

    description: 'The deadline for Assignment 3 has been extended to next Monday, April 14th at 11:59 PM.',

    courseName: 'Data Structures & Algorithms',

    timeAgo: '2 hours ago',

    type: NotificationType.announcement,

    isUnread: true,

  ),

  NotificationModel(

    id: '2',

    courseCode: 'CS305',

    title: 'Lab Session Rescheduled',

    description: 'Friday lab session has been moved to Thursday 2 PM in Lab 1. Please adjust your schedule.',

    courseName: 'Database Management Systems',

    timeAgo: '5 hours ago',

    type: NotificationType.alert,

    isUnread: true,

  ),

  NotificationModel(

    id: '3',

    courseCode: 'CS308',

    title: 'Class Starting Soon',

    description: 'Your class is starting in 30 minutes. Room 402.',

    courseName: 'Web Development',

    timeAgo: '1 day ago',

    type: NotificationType.reminder,

  ),

];



// --- WIDGET ---
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // Style Mapping - defining icons and colors based on type
    final styleMap = {
      NotificationType.announcement: {
        'bg': AppTheme.accentBlue,
        'icon': AppTheme.primaryColor,
        'data': Icons.campaign_outlined,
      },
      NotificationType.alert: {
        'bg': AppTheme.softOrange,
        'icon': AppTheme.warningOrange,
        'data': Icons.error_outline,
      },
      NotificationType.reminder: {
        'bg': AppTheme.softPurple,
        'icon': AppTheme.infoPurple,
        'data': Icons.notifications_none_outlined,
      },
    };

    final style = styleMap[notification.type]!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Badge
            CircleAvatar(
              backgroundColor: style['bg'] as Color,
              child: Icon(
                style['data'] as IconData, 
                color: style['icon'] as Color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Content
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
                          color: AppTheme.textSecondary, 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary, 
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.courseName,
                    style: const TextStyle(
                      color: AppTheme.textSecondary, 
                      fontSize: 12,
                    ),
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
          ),
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