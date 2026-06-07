import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Instructor Dashboard Integration Tests', () {
    testWidgets('Complete flow: Login -> Dashboard -> View Classes -> Logout',
            (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Navigate to role selection
          await tester.tap(find.text('Instructor'));
          await tester.pumpAndSettle();

          // Login flow
          await tester.enterText(
            find.byType(TextField).first,
            'instructor@example.com',
          );
          await tester.enterText(
            find.byType(TextField).last,
            'password123',
          );
          await tester.pumpAndSettle();

          await tester.tap(find.text('Login'));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Verify dashboard is shown
          expect(find.text('Welcome back,'), findsOneWidget);
          expect(find.text('My Classes'), findsOneWidget);
          expect(find.text('Quick Actions'), findsOneWidget);

          // Check stats cards
          expect(find.text('Total Classes'), findsOneWidget);
          expect(find.text('Students'), findsOneWidget);

          // Tap on New Class button
          await tester.tap(find.text('New Class'));
          await tester.pumpAndSettle();

          // Verify navigation to create class screen
          expect(find.text('Create New Class'), findsOneWidget);

          // Go back to dashboard
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          // Open drawer
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle();

          // Verify drawer items
          expect(find.text('Timetable'), findsOneWidget);
          expect(find.text('Logout'), findsOneWidget);
          expect(find.text('Delete Account'), findsOneWidget);
        });

    testWidgets('Create new class flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Login as instructor
      await tester.tap(find.text('Instructor'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'instructor@example.com',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap New Class
      await tester.tap(find.text('New Class'));
      await tester.pumpAndSettle();

      // Fill class creation form
      await tester.enterText(
        find.widgetWithText(TextField, 'Enter class name').first,
        'Integration Test Class',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Class Code').first,
        'IT101',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Description').first,
        'Test class created by integration test',
      );

      // Select days
      await tester.tap(find.text('Select Days'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday'));
      await tester.tap(find.text('Wednesday'));
      await tester.tap(find.text('Friday'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select time
      await tester.tap(find.text('Start Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10:00 AM'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('End Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('11:30 AM'));
      await tester.pumpAndSettle();

      // Submit form
      await tester.tap(find.text('Create Class'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify navigation back to dashboard
      expect(find.text('Integration Test Class'), findsOneWidget);
    });

    testWidgets('Empty state displays correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Login as instructor with no classes
      await tester.tap(find.text('Instructor'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'new_instructor@example.com',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify empty state message
      expect(find.text('No classes created yet'), findsOneWidget);
    });
  });
}