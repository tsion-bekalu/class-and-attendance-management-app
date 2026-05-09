class ClassEntity {
  final String id;
  final String name;
  final String description;
  final List<String> days;
  final String startTime;
  final String endTime;
  final int students;
  final int pending;
  final String status;

  ClassEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.students,
    required this.pending,
    required this.status,
  });
}
