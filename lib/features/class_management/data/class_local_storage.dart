import 'package:app/features/class_management/domain/entities/join_request.dart';


class ClassLocalStorage {
  static final List<Map<String, dynamic>> _classes = [
    {
    "id": "CS101",
    "name": "Computer Science 101",
    "students": 45,
    "status": "Active",
    "days": ["Sun", "Tue"],
    "startTime": "10:00 AM",
    "endTime": "12:00 PM",

    // ⭐ MOCK DATA FOR JOIN REQUESTS
    "pendingRequests": [
      {
        "name": "Mike Johnson",
        "email": "mike.j@university.edu",
        "studentId": "ST101",
        "status": "pending"
      },
      {
        "name": "Sarah Williams",
        "email": "sarah.w@university.edu",
        "studentId": "ST102",
        "status": "pending"
      },
      {
        "name": "Omar Khaled",
        "email": "omar.k@university.edu",
        "studentId": "ST103",
        "status": "pending"
      }
    ],

    "processedRequests": [
      {
        "name": "John Doe",
        "email": "john.doe@university.edu",
        "studentId": "ST201",
        "status": "approved"
      },
      {
        "name": "Jane Smith",
        "email": "jane.smith@university.edu",
        "studentId": "ST202",
        "status": "rejected"
      }
    ],

    "pending": 3,
  },
  ];

  static void addClass(Map<String, dynamic> classData) {
    _classes.add(classData);
  }

  static Map<String, dynamic>? getClassById(String id) {
    try {
      return _classes.firstWhere((c) => c['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static void deleteClass(String id) {
    _classes.removeWhere((c) => c['id'] == id);
  }

  static List<Map<String, dynamic>> getClasses() {
    return _classes;
  }

  static List<JoinRequest> getPendingRequests(String classId) {   
  final classData = getClassById(classId);
  if (classData == null) return [];

  return (classData["pendingRequests"] as List)
      .map((e) => JoinRequest.fromMap(e))
      .toList();
      }
  static List<JoinRequest> getProcessedRequests(String classId) {   final classData = getClassById(classId);
  if (classData == null) return [];

  return (classData["processedRequests"] as List)
      .map((e) => JoinRequest.fromMap(e))
      .toList();
       }
  static void approveRequest(String classId, String studentId) { final classData = getClassById(classId);
  if (classData == null) return;

  final pending = classData["pendingRequests"] as List;
  final processed = classData["processedRequests"] as List;

  final req = pending.firstWhere((r) => r["studentId"] == studentId);

  pending.removeWhere((r) => r["studentId"] == studentId);

  processed.add({
    ...req,
    "status": "approved",
  });

  classData["students"] += 1;
  classData["pending"] -= 1;
  }
  static void rejectRequest(String classId, String studentId) {  final classData = getClassById(classId);
  if (classData == null) return;

  final pending = classData["pendingRequests"] as List;
  final processed = classData["processedRequests"] as List;

  final req = pending.firstWhere((r) => r["studentId"] == studentId);

  pending.removeWhere((r) => r["studentId"] == studentId);

  processed.add({
    ...req,
    "status": "rejected",
  });
   classData["pending"] -= 1;
  }

}
