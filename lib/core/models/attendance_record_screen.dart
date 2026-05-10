import 'package:flutter/material.dart';

class AttendanceRecordScreen extends StatelessWidget {
  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        appBar: AppBar(
          title: const Text('Attendance Records'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black87,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sessions'),
              Tab(text: 'Students'),
            ],
            labelColor: Color(0xFF155DFC),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF155DFC),
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: const TabBarView(
          children: [
            // Sessions Tab (simplified as requested)
            Center(child: Text('Sessions View')),
            // Students Tab
            StudentsAttendanceList(),
          ],
        ),
      ),
    );
  }
}

class StudentsAttendanceList extends StatelessWidget {
  const StudentsAttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final students = [
      StudentData(
        name: 'Alice Johnson',
        email: 'alice.j@university.edu',
        presentCount: 4,
        totalSessions: 5,
        absentCount: 1,
      ),
      StudentData(
        name: 'Bob Wilson',
        email: 'bob.w@university.edu',
        presentCount: 4,
        totalSessions: 5,
        absentCount: 1,
      ),
      StudentData(
        name: 'Eve Martinez',
        email: 'eve.m@university.edu',
        presentCount: 5,
        totalSessions: 5,
        absentCount: 0,
      ),
      StudentData(
        name: 'David Brown',
        email: 'david.b@university.edu',
        presentCount: 2,
        totalSessions: 5,
        absentCount: 3,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        final attendancePercentage =
            (student.presentCount / student.totalSessions) * 100;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getPercentageColor(
                          attendancePercentage,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${attendancePercentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getPercentageColor(attendancePercentage),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildAttendanceStat(
                      label: 'Present',
                      count: student.presentCount,
                      total: student.totalSessions,
                      color: const Color(0xFF107C10),
                    ),
                    const SizedBox(width: 24),
                    _buildAttendanceStat(
                      label: 'Absent',
                      count: student.absentCount,
                      total: student.totalSessions,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: attendancePercentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: _getPercentageColor(attendancePercentage),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceStat({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '/$total',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 75) return const Color(0xFF107C10);
    if (percentage >= 50) return const Color(0xFFF2994A);
    return const Color(0xFFBA1A1A);
  }
}

class StudentData {
  final String name;
  final String email;
  final int presentCount;
  final int totalSessions;
  final int absentCount;

  const StudentData({
    required this.name,
    required this.email,
    required this.presentCount,
    required this.totalSessions,
    required this.absentCount,
  });
}
