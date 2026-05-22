import '../domain/entities/class_entity.dart';
import '../domain/repositories/class_repository.dart';
import 'class_local_storage.dart';
import 'package:app/features/class_management/domain/entities/join_request.dart';
import 'class_database.dart';

class ClassRepositoryImpl implements ClassRepository {
  final _database = ClassDatabase();
  @override
  Future<void> createClass(ClassEntity newClass) async {
    print("CREATING CLASS: ${newClass.name}");
    ClassLocalStorage.addClass({
      "id": newClass.id,
      "name": newClass.name,
      "description": newClass.description,
      "students": 45,
      "status": "Active",
      "days": newClass.days,
      "startTime": newClass.startTime,
      "endTime": newClass.endTime,
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
      ],
      "processedRequests": [
        {
          "name": "John Doe",
          "email": "john.doe@university.edu",
          "studentId": "ST201",
          "status": "approved",
        },
      ],

      "pending": 2,
    });
    print("LOCAL STORAGE SAVED");

    await _database.insertClass(newClass);

    print("SQLITE SAVED");
    final check = await _database.getClasses();
    print("DATABASE COUNT: ${check.length}");
  }

  @override
  Future<List<JoinRequest>> getPendingRequests(String classId) async {
    return ClassLocalStorage.getPendingRequests(classId);
  }

  @override
  Future<List<JoinRequest>> getProcessedRequests(String classId) async {
    return ClassLocalStorage.getProcessedRequests(classId);
  }

  @override
  Future<void> approveRequest(String classId, String studentId) async {
    ClassLocalStorage.approveRequest(classId, studentId);
  }

  @override
  Future<void> rejectRequest(String classId, String studentId) async {
    ClassLocalStorage.rejectRequest(classId, studentId);
  }

  @override
  Future<void> deleteClass(String classId) async {
    ClassLocalStorage.deleteClass(classId);
    await _database.deleteClass(classId);
  }

  @override
  Future<List<ClassEntity>> getClasses() async {
    final sqliteClasses = await _database.getClasses();

    final localClasses = ClassLocalStorage.getClasses().map((data) {
      return ClassEntity(
        id: data["id"],
        name: data["name"],
        description: data["description"] ?? "",
        days: List<String>.from(data["days"] ?? []),
        startTime: data["startTime"] ?? "",
        endTime: data["endTime"] ?? "",
        students: data["students"] ?? 0,
        pending: data["pending"] ?? 0,
        status: data["status"] ?? "Active",
      );
    }).toList();

    // merge both without duplicates
    final allClasses = [
      ...sqliteClasses,
      ...localClasses.where(
        (local) => !sqliteClasses.any((db) => db.id == local.id),
      ),
    ];

    return allClasses;
  }

  // RAW ACCESS FOR DASHBOARD
  Future<List<Map<String, dynamic>>> getClassesRaw() async {
    return ClassLocalStorage.getClasses();
  }

  // RAW ACCESS FOR CLASS DETAILS
  Future<Map<String, dynamic>?> getClassRawById(String id) async {
    return ClassLocalStorage.getClassById(id);
  }
}
