import '../repositories/class_repository.dart';
import '../entities/join_request.dart';

class GetPendingRequests {
  final ClassRepository repository;

  GetPendingRequests(this.repository);

  Future<List<JoinRequest>> call(String classId) {
    return repository.getPendingRequests(classId);
  }
}
