import '../entities/class_entity.dart';
import 'package:app/features/class_management/domain/entities/join_request.dart';

abstract class ClassRepository {
  Future<void> createClass(ClassEntity newClass);
  Future<void> deleteClass(String classId);
  Future<List<ClassEntity>> getClasses();

Future<List<JoinRequest>> getPendingRequests(String classId);
Future<List<JoinRequest>> getProcessedRequests(String classId);
Future<void> approveRequest(String classId, String studentId);
Future<void> rejectRequest(String classId, String studentId);
}

