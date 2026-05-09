import 'package:app/features/student/domain/models/notification.dart';

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