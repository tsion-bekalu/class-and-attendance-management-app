import '../repositories/class_repository.dart';
import '../entities/join_request.dart';

class GetProcessedRequests {
  final ClassRepository repository;

  GetProcessedRequests(this.repository);

  Future<List<JoinRequest>> call(String classId) {
    return repository.getProcessedRequests(classId);
  }
}
