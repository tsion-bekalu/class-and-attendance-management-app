import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/class_management/presentation/widgets/class_card.dart';

void main() {
  group('ClassCard Widget', () {
    bool wasTapped = false;

    setUp(() {
      wasTapped = false;
    });

    Widget createWidget({
      String name = 'Test Class',
      String code = 'TEST101',
      String time = 'Mon, Wed, Fri - 10:00 AM to 11:30 AM',
      String students = '30',
      int pending = 0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ClassCard(
            name: name,
            code: code,
            time: time,
            students: students,
            pending: pending,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      );
    }

    testWidgets('displays class name and code correctly', (tester) async {
      await tester.pumpWidget(createWidget(
        name: 'Data Structures',
        code: 'CS301',
      ));

      expect(find.text('Data Structures'), findsOneWidget);
      expect(find.text('Code: CS301'), findsOneWidget);
    });

    testWidgets('displays schedule information', (tester) async {
      const schedule = 'Mon, Wed, Fri - 10:00 AM to 11:30 AM';
      await tester.pumpWidget(createWidget(time: schedule));

      expect(find.text(schedule), findsOneWidget);
    });

    testWidgets('displays student count', (tester) async {
      await tester.pumpWidget(createWidget(students: '45'));

      expect(find.text('45'), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('shows active status chip', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('active'), findsOneWidget);
    });

    testWidgets('shows pending requests section when pending > 0',
            (tester) async {
          await tester.pumpWidget(createWidget(pending: 3, students: '30'));

          expect(find.text('30 pending join requests'), findsOneWidget);
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
        });

    testWidgets('does not show pending section when pending is 0',
            (tester) async {
          await tester.pumpWidget(createWidget(pending: 0));

          expect(find.text('0 pending join requests'), findsNothing);
        });

    testWidgets('calls onTap when tapped', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.tap(find.byType(ClassCard));
      await tester.pump();

      expect(wasTapped, true);
    });
  });
}