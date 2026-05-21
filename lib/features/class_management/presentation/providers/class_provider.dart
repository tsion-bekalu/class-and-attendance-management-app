import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/providers/app_providers.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/class_entity.dart';
import 'class_state.dart';

class ClassNotifier
    extends StateNotifier<ClassState> {
  final Ref ref;

  ClassNotifier(this.ref)
      : super(
          const ClassState(),
        );

  Future<void> getClasses() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      final repository = ref.read(
        classRepositoryProvider,
      );

      final classes =
          await repository
              .getClasses();

      state = state.copyWith(
        classes: classes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createClass(
    ClassEntity newClass,
  ) async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      final repository = ref.read(
        classRepositoryProvider,
      );

      await repository.createClass(
        newClass,
      );

      await getClasses();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteClass(
    String classId,
  ) async {
    try {
      final repository = ref.read(
        classRepositoryProvider,
      );

      await repository.deleteClass(
        classId,
      );

      await getClasses();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }
}

final classProvider =
    StateNotifierProvider<
      ClassNotifier,
      ClassState
    >((ref) {
      return ClassNotifier(ref);
    });