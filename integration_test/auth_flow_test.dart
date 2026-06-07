import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app;
import 'package:app/core/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    DatabaseHelper.databaseName = 'integration_test_auth_flow.db';
    DatabaseHelper.databasePath = join(
      Directory.systemTemp.path,
      DatabaseHelper.databaseName,
    );
    await DatabaseHelper.instance.close();

    await deleteDatabase(DatabaseHelper.databasePath!);
  });

  testWidgets('Student login flow: select student -> login -> reach student home',
      (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Step 1: Verify role selection screen (check role tiles are present)
    expect(find.text('Student'), findsOneWidget);
    expect(find.text('Instructor'), findsOneWidget);

    // Step 2: Select Student role
    await tester.ensureVisible(find.byKey(const Key('roleSelectionStudentTile')));
    await tester.tap(find.byKey(const Key('roleSelectionStudentTile')));
    await tester.pumpAndSettle();

    // Step 3: Verify role is selected and continue button is enabled
    final continueButton = find.byKey(const Key('roleSelectionContinueButton'));
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Step 4: Verify login screen appears
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    // Step 5: Enter login credentials
    final emailField = find.byKey(const Key('loginEmailField'));
    final passwordField = find.byKey(const Key('loginPasswordField'));
    await tester.ensureVisible(emailField);
    await tester.tap(emailField);
    await tester.enterText(emailField, 'student@uni.com');
    await tester.pumpAndSettle();

    await tester.ensureVisible(passwordField);
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'password123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Step 6: Tap sign in button
    final signInButton = find.byKey(const Key('loginSubmitButton'));
    await tester.ensureVisible(signInButton);
    await tester.pumpAndSettle();
    final signInWidget = tester.widget<ElevatedButton>(signInButton);
    expect(signInWidget.onPressed, isNotNull);
    await tester.tap(signInButton);
    await tester.pumpAndSettle(const Duration(seconds: 12));

    // Debug: make sure there is no auth error displayed
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('Invalid'), findsNothing);

    // Step 7: Verify student home screen is reached
    expect(find.text('My Classes'), findsOneWidget);
  });

  testWidgets('Instructor login flow: select instructor -> login -> reach dashboard',
      (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Step 1: Verify role selection screen (check role tiles are present)
    expect(find.byKey(const Key('roleSelectionStudentTile')), findsOneWidget);
    expect(find.byKey(const Key('roleSelectionInstructorTile')), findsOneWidget);

    // Step 2: Select Instructor role
    await tester.ensureVisible(find.byKey(const Key('roleSelectionInstructorTile')));
    await tester.tap(find.byKey(const Key('roleSelectionInstructorTile')));
    await tester.pumpAndSettle();

    // Step 3: Continue to login screen
    final continueButton = find.byKey(const Key('roleSelectionContinueButton'));
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Step 4: Verify login screen appears
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    // Step 5: Enter instructor login credentials
    final emailField = find.byKey(const Key('loginEmailField'));
    final passwordField = find.byKey(const Key('loginPasswordField'));
    await tester.ensureVisible(emailField);
    await tester.tap(emailField);
    await tester.enterText(emailField, 'instructor@uni.com');
    await tester.pumpAndSettle();

    await tester.ensureVisible(passwordField);
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'password123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Step 6: Tap sign in button
    final signInButton = find.byKey(const Key('loginSubmitButton'));
    await tester.ensureVisible(signInButton);
    await tester.pumpAndSettle();
    final signInWidget = tester.widget<ElevatedButton>(signInButton);
    expect(signInWidget.onPressed, isNotNull);
    await tester.tap(signInButton);
    await tester.pumpAndSettle(const Duration(seconds: 12));

    // Debug: make sure there is no auth error displayed
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('Invalid'), findsNothing);

    // Step 7: Verify navigation occurred (instructor dashboard should appear)
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Total Classes'), findsOneWidget);
    expect(find.text('My Classes'), findsOneWidget);
  });
}
