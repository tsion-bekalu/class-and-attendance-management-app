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