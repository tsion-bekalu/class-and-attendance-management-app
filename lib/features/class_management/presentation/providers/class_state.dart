import '../../domain/entities/class_entity.dart';

class ClassState {
  final List<ClassEntity> classes;
  final bool isLoading;
  final String? error;

  const ClassState({
    this.classes = const [],
    this.isLoading = false,
    this.error,
  });

  ClassState copyWith({
    List<ClassEntity>? classes,
    bool? isLoading,
    String? error,
  }) {
    return ClassState(
      classes:
          classes ?? this.classes,
      isLoading:
          isLoading ??
          this.isLoading,
      error: error,
    );
  }
}