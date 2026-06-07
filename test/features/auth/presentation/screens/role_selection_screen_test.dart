import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/screens/role_selection.dart';

void main() {
  testWidgets('Continue button is disabled until a role is selected',
      (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RoleSelectionScreen(),
        ),
      ),
    );

    final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
    expect(continueButton, findsOneWidget);
    final buttonWidget = tester.widget<ElevatedButton>(continueButton);
    expect(buttonWidget.onPressed, isNull);

    await tester.tap(find.text('Student'));
    await tester.pumpAndSettle();

    final updatedButton = tester.widget<ElevatedButton>(continueButton);
    expect(updatedButton.onPressed, isNotNull);
  });
}
