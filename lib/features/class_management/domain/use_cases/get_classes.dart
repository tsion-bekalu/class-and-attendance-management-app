import '../repositories/class_repository.dart';
import '../entities/class_entity.dart';

class GetClasses {
  final ClassRepository repository;

  GetClasses(this.repository);

  Future<List<ClassEntity>> call(
    String instructorId,
  ) async {
    return await repository.getClasses(
      instructorId,
    );
  }
}
