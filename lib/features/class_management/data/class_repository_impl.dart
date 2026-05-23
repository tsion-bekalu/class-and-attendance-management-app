import '../domain/entities/class_entity.dart';
import '../domain/repositories/class_repository.dart';
import 'class_local_storage.dart';
import 'package:app/features/class_management/domain/entities/join_request.dart';
import 'class_database.dart';

class ClassRepositoryImpl implements ClassRepository {
  final _database = ClassDatabase();
  @override
  Future<void> createClass(ClassEntity newClass) async {
    await _database.insertClass(newClass);

    await _database.getClasses();
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
    await _database.deleteClass(classId);
  }

  @override
  Future<List<ClassEntity>> getClasses() async {
    return await _database.getClasses();
  }

  // RAW ACCESS FOR DASHBOARD
  Future<List<Map<String, dynamic>>> getClassesRaw() async {
    return ClassLocalStorage.getClasses();
  }

  Future<Map<String, dynamic>?> getClassRawById(String id) async {
    final classEntity = await _database.getClassById(id);

    if (classEntity == null) return null;

    return {
      "id": classEntity.id,
      "name": classEntity.name,
      "description": classEntity.description,
      "days": classEntity.days,
      "startTime": classEntity.startTime,
      "endTime": classEntity.endTime,
      "students": classEntity.students,
      "pending": classEntity.pending,
      "status": classEntity.status,
    };
  }
}
