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

      // ⭐ PENDING REQUESTS
      "pendingRequests": [
        {
          "name": "Mike Johnson",
          "email": "mike.j@university.edu",
          "studentId": "ST101",
          "status": "pending",
        },
        {
          "name": "Sarah Williams",
          "email": "sarah.w@university.edu",
          "studentId": "ST102",
          "status": "pending",
        },
        {
          "name": "Omar Khaled",
          "email": "omar.k@university.edu",
          "studentId": "ST103",
          "status": "pending",
        },
      ],

      // ⭐ PROCESSED REQUESTS
      "processedRequests": [
        {
          "name": "John Doe",
          "email": "john.doe@university.edu",
          "studentId": "ST201",
          "status": "approved",
        },
        {
          "name": "Jane Smith",
          "email": "jane.smith@university.edu",
          "studentId": "ST202",
          "status": "rejected",
        },
      ],

      "pending": 3,
    },
  ];

  // ➕ ADD CLASS
  static void addClass(Map<String, dynamic> classData) {
    _classes.add(classData);
  }

  // 🔍 GET CLASS BY ID
  static Map<String, dynamic>? getClassById(
    String id,
  ) {
    try {
      return _classes.firstWhere(
        (c) => c["id"] == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ❌ DELETE CLASS
  static void deleteClass(String id) {
    _classes.removeWhere(
      (c) => c["id"] == id,
    );
  }

  // 📚 GET ALL CLASSES
  static List<Map<String, dynamic>>
      getClasses() {
    return _classes;
  }

  // ⏳ GET PENDING REQUESTS
  static List<JoinRequest> getPendingRequests(
    String classId,
  ) {
    final classData = getClassById(classId);

    if (classData == null) return [];

    return (classData["pendingRequests"] as List)
        .map(
          (e) => JoinRequest.fromMap(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  // ✅ GET PROCESSED REQUESTS
  static List<JoinRequest>
      getProcessedRequests(
    String classId,
  ) {
    final classData = getClassById(classId);

    if (classData == null) return [];

    return (classData["processedRequests"]
            as List)
        .map(
          (e) => JoinRequest.fromMap(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  // ✅ APPROVE REQUEST
  static void approveRequest(
    String classId,
    String studentId,
  ) {
    final classData = getClassById(classId);

    if (classData == null) return;

    final List pending =
       List.from( classData["pendingRequests"]);

    final List processed =
        List.from(classData["processedRequests"]);

    final index = pending.indexWhere(
      (r) => r["studentId"] == studentId,
    );

    if (index == -1) return;

    final Map<String, dynamic> req = Map<String, dynamic>.from(
      pending[index],
    );

    // REMOVE FROM PENDING
    pending.removeAt(index);

    // ADD TO PROCESSED
    processed.add({
    "name": req["name"],
    "email": req["email"],
    "studentId": req["studentId"],
    "status": "approved",

    });

    // UPDATE COUNTS
  classData["pendingRequests"] = pending;
  classData["processedRequests"] = processed;

  classData["students"] += 1;

  if (classData["pending"] > 0) {
    classData["pending"] -= 1;
  }
}

  // ❌ REJECT REQUEST
  static void rejectRequest(
    String classId,
    String studentId,
  ) {
    final classData = getClassById(classId);

    if (classData == null) return;

    final List pending =
        List.from(classData["pendingRequests"]);

    final List processed =
        List.from(classData["processedRequests"]);

    final index = pending.indexWhere(
      (r) => r["studentId"] == studentId,
    );

    if (index == -1) return;

    final Map<String, dynamic> req =
        Map<String, dynamic>.from(
      pending[index],
    );

    // REMOVE FROM PENDING
    pending.removeAt(index);

    // ADD TO PROCESSED
    processed.add({
     "name": req["name"],
    "email": req["email"],
    "studentId": req["studentId"],
    "status": "rejected",
    });

  classData["pendingRequests"] = pending;
  classData["processedRequests"] = processed;

  if (classData["pending"] > 0) {
    classData["pending"] -= 1;
  }
}}