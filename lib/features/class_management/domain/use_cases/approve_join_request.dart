import '../repositories/class_repository.dart';
import '../entities/join_request.dart';

class ApproveJoinRequest {
  final ClassRepository repository;

  ApproveJoinRequest(this.repository);

  Future<void> call(String classId, JoinRequest request) {
    return repository.approveRequest(classId, request.studentId);
  }
}
