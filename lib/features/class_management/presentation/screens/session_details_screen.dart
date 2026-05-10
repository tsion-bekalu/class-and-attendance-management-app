import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session_record.dart';


class SessionDetailsScreen extends StatelessWidget {
  final AttendanceSession session;

  const SessionDetailsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final attendeesList = session.attendees ?? [];

    final presentStudents = attendeesList .where((s) => s.isPresent).toList();
    final absentStudents = attendeesList.where((s) => !s.isPresent).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
  toolbarHeight: 100,
  backgroundColor: AppTheme.primaryColor,
  elevation: 0,
  titleSpacing: 0,
  automaticallyImplyLeading: false,
  title: Row(
    children: [
      const SizedBox(width: 15),

      Container(
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
        ),
      ),

      const SizedBox(width: 12),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Session Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
      const SizedBox(height: 3),

          Text(
            "${session.date} at ${session.time}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ],
  ),
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Present", presentStudents.length),
          ...presentStudents.map((s) => _buildStudentTile(s)),
          const SizedBox(height: 24),
          _buildSectionHeader("Absent", absentStudents.length),
          ...absentStudents.map((s) => _buildStudentTile(s)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        "$title ($count)",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _buildStudentTile(SessionAttendee attendee) {
    final Color statusColor = attendee.isPresent ? const Color.fromARGB(255, 62, 201, 69) : const Color.fromARGB(255, 204, 54, 54);
    final Color statusBg = attendee.isPresent ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusBg.withOpacity(0.5),
            child: Icon(Icons.person_outline, color: statusColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(attendee.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
            child: Text(
              attendee.isPresent ? "Present" : "Absent",
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}