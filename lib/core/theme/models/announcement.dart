class Announcement {
  final String id;
  final String classId;
  final String title;
  
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Announcement({
    required this.id,
    required this.classId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}