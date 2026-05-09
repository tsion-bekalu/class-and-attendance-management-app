import '../repositories/class_repository.dart';
import '../entities/class_entity.dart';

class GetClasses {
  final ClassRepository repository;

  GetClasses(this.repository);

  Future<List<ClassEntity>> call() {
    return repository.getClasses();
  }
}
