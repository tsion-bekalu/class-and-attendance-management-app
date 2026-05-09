import '../entities/class_entity.dart';

abstract class ClassRepository {
  Future<void> createClass(ClassEntity newClass);
  Future<void> deleteClass(String classId);
  Future<List<ClassEntity>> getClasses();
}
