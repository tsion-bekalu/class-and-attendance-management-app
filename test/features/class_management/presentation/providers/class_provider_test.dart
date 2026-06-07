import 'package:app/core/providers/app_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/class_management/presentation/providers/class_provider.dart';
import 'package:app/features/class_management/domain/entities/class_entity.dart';
import 'package:app/features/class_management/domain/repositories/class_repository.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';

// Mocks
class MockClassRepository extends Mock implements ClassRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late ProviderContainer container;
  late MockClassRepository mockClassRepository;
  late MockAuthRepository mockAuthRepository;
  late MockAuthResponse mockAuthResponse;

  setUp(() {
    mockClassRepository = MockClassRepository();
    mockAuthRepository = MockAuthRepository();
    mockAuthResponse = MockAuthResponse();

    container = ProviderContainer(
      overrides: [
        classRepositoryProvider.overrideWithValue(mockClassRepository),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ClassNotifier', () {
    final testClasses = [
      const ClassEntity(
        id: 'CS301',
        name: 'Data Structures',
        description: 'Course',
        days: ['Mon', 'Wed', 'Fri'],
        startTime: '10:00 AM',
        endTime: '11:30 AM',
        students: 35,
        pending: 5,
        status: 'Active',
        instructorId: 'inst123',
        instructorName: 'Dr. Johnson',
      ),
      const ClassEntity(
        id: 'CS305',
        name: 'Databases',
        description: 'Course',
        days: ['Tue', 'Thu'],
        startTime: '10:00 AM',
        endTime: '11:30 AM',
        students: 28,
        pending: 2,
        status: 'Active',
        instructorId: 'inst123',
        instructorName: 'Dr. Johnson',
      ),
    ];

    test('initial state is loading', () {
      final state = container.read(classProvider);
      expect(state.isLoading, true);
      expect(state.classes, isEmpty);
    });

    test('getClasses loads classes successfully', () async {
      // Setup mocks
      when(
        () => mockAuthRepository.getCachedSession(),
      ).thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.userId).thenReturn('inst123');
      when(
        () => mockClassRepository.getClasses('inst123'),
      ).thenAnswer((_) async => testClasses);

      // Wait for initial load
      await container.read(classProvider.notifier).getClasses();
      await pumpEventQueue();

      final state = container.read(classProvider);
      expect(state.isLoading, false);
      expect(state.classes.length, 2);
      expect(state.classes[0].name, 'Data Structures');
      expect(state.classes[1].name, 'Databases');
    });

    test('getClasses handles error correctly', () async {
      when(
        () => mockAuthRepository.getCachedSession(),
      ).thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.userId).thenReturn('inst123');
      when(
        () => mockClassRepository.getClasses('inst123'),
      ).thenThrow(Exception('Network error'));

      await container.read(classProvider.notifier).getClasses();

      final state = container.read(classProvider);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);
    });

    test('getClasses handles null session', () async {
      when(
        () => mockAuthRepository.getCachedSession(),
      ).thenAnswer((_) async => null);

      await container.read(classProvider.notifier).getClasses();

      final state = container.read(classProvider);
      expect(state.isLoading, false);
      expect(state.classes, isEmpty);
    });

    test('createClass adds new class successfully', () async {
      final newClass = ClassEntity(
        id: 'CS401',
        name: 'Mobile Development',
        description: 'Flutter course',
        days: ['Mon', 'Wed'],
        startTime: '2:00 PM',
        endTime: '3:30 PM',
        students: 0,
        pending: 0,
        status: 'Active',
        instructorId: 'inst123',
        instructorName: 'Dr. Johnson',
      );

      when(
        () => mockAuthRepository.getCachedSession(),
      ).thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.userId).thenReturn('inst123');
      when(
        () => mockClassRepository.getClasses('inst123'),
      ).thenAnswer((_) async => []);
      when(
        () => mockClassRepository.createClass(newClass),
      ).thenAnswer((_) async => {});

      await container.read(classProvider.notifier).createClass(newClass);

      verify(() => mockClassRepository.createClass(newClass)).called(1);
    });

    test('deleteClass removes class successfully', () async {
      const classId = 'CS301';

      when(
        () => mockClassRepository.deleteClass(classId),
      ).thenAnswer((_) async => {});

      await container.read(classProvider.notifier).deleteClass(classId);

      verify(() => mockClassRepository.deleteClass(classId)).called(1);
    });
  });
}
