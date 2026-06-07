import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/class_management/presentation/providers/class_state.dart';
import 'package:app/features/class_management/domain/entities/class_entity.dart';

void main() {
  group('ClassState', () {
    final testClasses = [
      const ClassEntity(
        id: '1',
        name: 'Class 1',
        description: '',
        days: [],
        startTime: '',
        endTime: '',
        students: 0,
        pending: 0,
        status: '',
        instructorId: '',
        instructorName: '',
      ),
    ];

    test('initial state has empty classes and not loading', () {
      const state = ClassState();

      expect(state.classes, isEmpty);
      expect(state.isLoading, true);
      expect(state.error, isNull);
    });

    test('copyWith updates properties correctly', () {
      const initialState = ClassState();

      final updatedState = initialState.copyWith(
        classes: testClasses,
        isLoading: false,
        error: 'Something went wrong',
      );

      expect(updatedState.classes, testClasses);
      expect(updatedState.isLoading, false);
      expect(updatedState.error, 'Something went wrong');
    });

    test('copyWith preserves unchanged properties', () {
      const initialState = ClassState();

      final updatedState = initialState.copyWith(
        classes: testClasses,
      );

      expect(updatedState.classes, testClasses);
      expect(updatedState.isLoading, initialState.isLoading);
      expect(updatedState.error, initialState.error);
    });
  });
}