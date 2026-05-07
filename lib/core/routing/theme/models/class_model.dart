enum ClassStatus { active, cancelled }

class Class {
  final String id;
  final String name;
  final String joinCode;
  final String instructorId;
  final List<String> enrolledStudentIds;
  final ClassStatus status;
  final String day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Class({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.instructorId,
    required this.enrolledStudentIds,
    required this.status,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  String scheduleString(BuildContext context) =>
      '$day ${startTime.format(context)} - ${endTime.format(context)}';
}