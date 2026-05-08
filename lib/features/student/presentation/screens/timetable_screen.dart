import 'package:flutter/material.dart';
import '../../../../core/routing/theme/app_theme.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using your theme's background color
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: mockSchedule.length,
              itemBuilder: (context, index) {
                return ScheduleCard(entry: mockSchedule[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
    width: double.infinity,
    decoration: const BoxDecoration(
      color: AppTheme.primaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Timetable",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  "Weekly class schedule",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
              .map((day) => _dayChip(day, day == 'Mon'))
              .toList(),
        ),
      ],
    ),
  );
}
  Widget _dayChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final TimetableEntry entry;
  const ScheduleCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Using AppTheme's margin and surface colors
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
                    Text(
                      entry.duration, 
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
    );
  }
}

class TimetableEntry {
  final String title;
  final String courseCode;
  final String time;
  final String location;
  final String duration;
  final Color accentColor;

  TimetableEntry({
    required this.title,
    required this.courseCode,
    required this.time,
    required this.location,
    required this.duration,
    required this.accentColor,
  });
}
// Updated Mock Data using the new AppTheme colors
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