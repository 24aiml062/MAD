import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_student_companion/main.dart';
import 'package:smart_student_companion/screens/login_screen.dart';
import 'package:smart_student_companion/screens/dashboard_screen.dart';
import 'package:smart_student_companion/screens/profile_screen.dart';

void main() {
  testWidgets(
    'Splash Screen renders university branding and progress indicator',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SmartStudentCompanionApp());

      // Verify title and university branding
      expect(find.text('Smart Student Companion'), findsOneWidget);
      expect(
        find.text('CHARUSAT – Faculty of Technology & Engineering'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('Login Screen validates empty inputs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify login title and sign-in button
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Clear inputs and submit
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, '');
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Verify validation error messages
    expect(find.text('Please enter your student ID or email'), findsOneWidget);
  });

  testWidgets('Dashboard Screen renders student information and module cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    // Verify student name and header details
    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('Timetable'), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
  });

  testWidgets('Profile Screen displays academic stats and university details', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    // Verify profile details
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Roll No: 24AIML062'), findsOneWidget);
    expect(find.text('8.75'), findsOneWidget);
    expect(find.text('Log Out of Account'), findsOneWidget);
  });
}
