import '../repositories/class_repository.dart';
import '../entities/join_request.dart';

class RejectJoinRequest {
  final ClassRepository repository;

  RejectJoinRequest(this.repository);

  Future<void> call(String classId, JoinRequest request) {
    return repository.rejectRequest(classId, request.studentId);
  }
}
