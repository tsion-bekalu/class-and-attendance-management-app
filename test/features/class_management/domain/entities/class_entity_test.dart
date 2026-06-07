import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/class_management/domain/entities/class_entity.dart';

void main() {
  group('ClassEntity', () {
    const testClass = ClassEntity(
      id: 'CS301',
      name: 'Data Structures',
      description: 'Advanced data structures course',
      days: ['Monday', 'Wednesday', 'Friday'],
      startTime: '10:00 AM',
      endTime: '11:30 AM',
      students: 35,
      pending: 5,
      status: 'Active',
      instructorId: 'inst123',
      instructorName: 'Dr. Sarah Johnson',
    );

    test('should create instance with correct values', () {
      expect(testClass.id, 'CS301');
      expect(testClass.name, 'Data Structures');
      expect(testClass.description, 'Advanced data structures course');
      expect(testClass.days.length, 3);
      expect(testClass.students, 35);
      expect(testClass.pending, 5);
      expect(testClass.status, 'Active');
    });

    test('should convert to and from map correctly', () {
      final map = testClass.toMap();
      final convertedClass = ClassEntity.fromMap(map);

      expect(convertedClass.id, testClass.id);
      expect(convertedClass.name, testClass.name);
      expect(convertedClass.days, testClass.days);
      expect(convertedClass.students, testClass.students);
    });

    test('should copy with updated values', () {
      final updatedClass = testClass.copyWith(
        name: 'Advanced Algorithms',
        students: 40,
      );

      expect(updatedClass.name, 'Advanced Algorithms');
      expect(updatedClass.students, 40);
      expect(updatedClass.id, testClass.id); // Unchanged
    });

    test('should handle empty optional fields', () {
      const minimalClass = ClassEntity(
        id: 'MIN101',
        name: 'Minimal Class',
        description: '',
        days: [],
        startTime: '',
        endTime: '',
        students: 0,
        pending: 0,
        status: 'Active',
        instructorId: '',
        instructorName: '',
      );

      expect(minimalClass.description, '');
      expect(minimalClass.days.isEmpty, true);
      expect(minimalClass.students, 0);
    });
  });
}
