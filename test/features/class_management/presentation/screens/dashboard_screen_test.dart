import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/class_management/presentation/screens/dashboard_screen.dart';
import 'package:app/features/class_management/presentation/providers/class_provider.dart';
import 'package:app/features/class_management/presentation/providers/class_state.dart';
import 'package:app/features/class_management/domain/entities/class_entity.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/models/auth_response.dart';
import 'package:app/core/providers/app_providers.dart';

// Mocks
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  group('InstructorDashboardScreen', () {
    late MockAuthRepository mockAuthRepository;
    late MockAuthResponse mockAuthResponse;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockAuthResponse = MockAuthResponse();

      registerFallbackValue(const ClassEntity(
        id: '',
        name: '',
        description: '',
        days: [],
        startTime: '',
        endTime: '',
        students: 0,
        pending: 0,
        status: '',
        instructorId: '',
        instructorName: '',
      ));
    });

    Future<void> pumpDashboard(
        WidgetTester tester,
        List<ClassEntity> classes,
        ) async {
      // Create a real ClassNotifier with test data
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      // Get the notifier and set its state
      final classNotifier = container.read(classProvider.notifier);
      classNotifier.state = ClassState(classes: classes, isLoading: false);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: InstructorDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('displays welcome message with instructor name',
            (tester) async {
          when(() => mockAuthRepository.getCachedSession())
              .thenAnswer((_) async => mockAuthResponse);
          when(() => mockAuthResponse.name).thenReturn('Dr. Sarah Johnson');
          when(() => mockAuthResponse.role).thenReturn('instructor');

          await pumpDashboard(tester, []);

          expect(find.text('Welcome back,'), findsOneWidget);
          expect(find.text('Dr. Sarah Johnson'), findsOneWidget);
        });

    testWidgets('displays correct total classes count', (tester) async {
      final classes = [
        const ClassEntity(
          id: '1',
          name: 'Class 1',
          description: '',
          days: [],
          startTime: '',
          endTime: '',
          students: 10,
          pending: 0,
          status: 'Active',
          instructorId: '',
          instructorName: '',
        ),
        const ClassEntity(
          id: '2',
          name: 'Class 2',
          description: '',
          days: [],
          startTime: '',
          endTime: '',
          students: 15,
          pending: 0,
          status: 'Active',
          instructorId: '',
          instructorName: '',
        ),
      ];

      when(() => mockAuthRepository.getCachedSession())
          .thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.name).thenReturn('Instructor');

      await pumpDashboard(tester, classes);

      expect(find.text('Total Classes'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('displays correct total students count', (tester) async {
      final classes = [
        const ClassEntity(
          id: '1',
          name: 'Class 1',
          description: '',
          days: [],
          startTime: '',
          endTime: '',
          students: 10,
          pending: 0,
          status: 'Active',
          instructorId: '',
          instructorName: '',
        ),
        const ClassEntity(
          id: '2',
          name: 'Class 2',
          description: '',
          days: [],
          startTime: '',
          endTime: '',
          students: 15,
          pending: 0,
          status: 'Active',
          instructorId: '',
          instructorName: '',
        ),
      ];

      when(() => mockAuthRepository.getCachedSession())
          .thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.name).thenReturn('Instructor');

      await pumpDashboard(tester, classes);

      expect(find.text('Students'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('shows "No classes created yet" when class list is empty',
            (tester) async {
          when(() => mockAuthRepository.getCachedSession())
              .thenAnswer((_) async => mockAuthResponse);
          when(() => mockAuthResponse.name).thenReturn('Instructor');

          await pumpDashboard(tester, []);

          expect(find.text('No classes created yet'), findsOneWidget);
        });

    testWidgets('displays class cards for each class', (tester) async {
      final classes = [
        const ClassEntity(
          id: 'CS301',
          name: 'Data Structures',
          description: '',
          days: ['Mon', 'Wed', 'Fri'],
          startTime: '10:00 AM',
          endTime: '11:30 AM',
          students: 35,
          pending: 5,
          status: 'Active',
          instructorId: '',
          instructorName: '',
        ),
      ];

      when(() => mockAuthRepository.getCachedSession())
          .thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.name).thenReturn('Instructor');

      await pumpDashboard(tester, classes);

      expect(find.text('Data Structures'), findsOneWidget);
      expect(find.text('Code: CS301'), findsOneWidget);
      expect(find.text('35'), findsOneWidget);
    });

    testWidgets('quick actions are displayed', (tester) async {
      when(() => mockAuthRepository.getCachedSession())
          .thenAnswer((_) async => mockAuthResponse);
      when(() => mockAuthResponse.name).thenReturn('Instructor');

      await pumpDashboard(tester, []);

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('New Class'), findsOneWidget);
      expect(find.text('Timetable'), findsOneWidget);
    });
  });
}

// Helper widget to provide a custom ProviderScope
class UncontrolledProviderScope extends StatelessWidget {
  final ProviderContainer container;
  final Widget child;

  const UncontrolledProviderScope({
    super.key,
    required this.container,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
      child: child,
    );
  }
}

