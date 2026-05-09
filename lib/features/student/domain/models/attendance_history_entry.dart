
class AttendanceHistoryEntry {
  final String topic;
  final String date;
  final String time;
  final bool isPresent;

  AttendanceHistoryEntry({
    required this.topic,
    required this.date,
    required this.time,
    required this.isPresent,
  });
}