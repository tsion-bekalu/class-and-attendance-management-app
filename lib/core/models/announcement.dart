class Announcement {
  final String id;
  final String classId;
  final String className;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Announcement({
    required this.id,
    required this.classId,
    required this.className,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  
  String get formattedDate {
    final month = createdAt.month;
    final day = createdAt.day;
    final year = createdAt.year;
    return '$month/$day/$year';
  }
}