import 'package:app/core/models/time_table_entry.dart';
import '../../../../core/routing/theme/app_theme.dart';


final List<TimetableEntry> mockSchedule = [
  TimetableEntry(
    title: "Data Structures & Algorithms",
    courseCode: "CS301",
    time: "10:00 AM",
    location: "Room 301",
    duration: "1h 30m",
    accentColor: AppTheme.primaryColor,
  ),
  TimetableEntry(
    title: "Web Development Lab",
    courseCode: "CS308",
    time: "2:00 PM",
    location: "Lab 2",
    duration: "1h",
    accentColor: AppTheme.infoPurple, // Using your new status color
  ),
];