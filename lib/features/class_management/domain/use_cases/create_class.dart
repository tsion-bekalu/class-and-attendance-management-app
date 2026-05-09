import '../repositories/class_repository.dart';
import '../entities/class_entity.dart';

class CreateClass {
  final ClassRepository repository;

  CreateClass(this.repository);

  Future<void> call(ClassEntity newClass) {
    return repository.createClass(newClass);
  }
}
