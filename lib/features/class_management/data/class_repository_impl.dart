import '../domain/entities/class_entity.dart';
import '../domain/repositories/class_repository.dart';
import 'class_local_storage.dart';

class ClassRepositoryImpl implements ClassRepository {
  @override
  Future<void> createClass(ClassEntity newClass) async {
    ClassLocalStorage.addClass({
      "id": newClass.id,
      "name": newClass.name,
      "description": newClass.description,
      "students": 45,
      "status": "Active",
      "days": newClass.days,
      "startTime": newClass.startTime,
      "endTime": newClass.endTime,
      "pending": 3,
    });
  }

  @override
  Future<void> deleteClass(String classId) async {
    ClassLocalStorage.deleteClass(classId);
  }

  @override
  Future<List<ClassEntity>> getClasses() async {
    final rawList = ClassLocalStorage.getClasses();

    return rawList.map((data) {
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
