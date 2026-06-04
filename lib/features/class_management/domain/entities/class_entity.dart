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
  final String instructorId;
  final String instructorName;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.students,
    required this.pending,
    required this.status,
    required this.instructorId,
    required this.instructorName,
  });

  factory ClassEntity.fromMap(Map<String, dynamic> map) {
    return ClassEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      days: List<String>.from(map['days'] ?? []),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      students: map['students'] ?? 0,
      pending: map['pending'] ?? 0,
      status: map['status'] ?? 'Active',
      instructorId: map['instructorId'] ?? '',
      instructorName: map['instructorName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
      'students': students,
      'pending': pending,
      'status': status,
      'instructorId': instructorId,
      'instructorName': instructorName,
    };
  }

  ClassEntity copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? days,
    String? startTime,
    String? endTime,
    int? students,
    int? pending,
    String? status,
    String? instructorId,
    String? instructorName,
  }) {
    return ClassEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      students: students ?? this.students,
      pending: pending ?? this.pending,
      status: status ?? this.status,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
    );
  }
}
