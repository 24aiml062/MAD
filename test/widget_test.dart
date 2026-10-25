import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_student_companion/main.dart';
import 'package:smart_student_companion/screens/login_screen.dart';
import 'package:smart_student_companion/screens/dashboard_screen.dart';
import 'package:smart_student_companion/screens/profile_screen.dart';
import 'package:smart_student_companion/screens/attendance_screen.dart';
import 'package:smart_student_companion/screens/timetable_screen.dart';
import 'package:smart_student_companion/screens/assignments_screen.dart';
import 'package:smart_student_companion/screens/notifications_screen.dart';
import 'package:smart_student_companion/screens/faculty_screen.dart';
import 'package:smart_student_companion/screens/event_gallery_screen.dart';
import 'package:smart_student_companion/screens/settings_screen.dart';

void main() {
  testWidgets('Splash Screen renders university branding and progress indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartStudentCompanionApp());
    expect(find.text('Smart Student Companion'), findsOneWidget);
    expect(find.text('CHARUSAT – Faculty of Technology & Engineering'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Login Screen validates empty inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, '');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Please enter your student ID or email'), findsOneWidget);
  });

  testWidgets('Dashboard Screen renders student information and module cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.text('Timetable'), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Event Gallery'), findsOneWidget);
  });

  testWidgets('Profile Screen displays academic stats and university details', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Roll No: 24AIML062'), findsOneWidget);
    expect(find.text('8.75'), findsOneWidget);
    expect(find.text('Log Out of Account'), findsOneWidget);
  });

  testWidgets('Attendance Screen renders overall percentage and subject progress', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AttendanceScreen()));
    expect(find.text('Attendance Summary'), findsOneWidget);
    expect(find.text('91%'), findsOneWidget);
    expect(find.text('Mobile Application Development (MAD)'), findsOneWidget);
    expect(find.text('Database Management Systems (DBMS)'), findsOneWidget);
  });

  testWidgets('Timetable Screen renders day selector and lecture schedule', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TimetableScreen()));
    expect(find.text('Class Timetable'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Mobile Application Development (MAD)'), findsOneWidget);
  });

  testWidgets('Assignments Screen renders priority chips and due dates', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AssignmentsScreen()));
    expect(find.text('Academic Assignments'), findsOneWidget);
    expect(find.text('High Priority'), findsOneWidget);
    expect(find.text('Practical 3: Responsive UI & Layout Design'), findsOneWidget);
  });

  testWidgets('Notifications Screen renders alert categories and announcements', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotificationsScreen()));
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Mid-Semester Internal Exam Schedule'), findsOneWidget);
  });

  testWidgets('Faculty Screen renders professor directory and department info', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FacultyScreen()));
    expect(find.text('Faculty Information'), findsOneWidget);
    expect(find.text('Prof. Jayesh Sharma'), findsOneWidget);
    expect(find.text('Dr. Priya Joshi'), findsOneWidget);
  });

  testWidgets('Event Gallery Screen renders responsive grid of 6 campus events', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EventGalleryScreen()));
    expect(find.text('Event Gallery'), findsOneWidget);
    expect(find.text('National AI & Mobile Hackathon'), findsOneWidget);
    expect(find.text('AI & Edge Computing Summit'), findsOneWidget);
  });

  testWidgets('Settings Screen renders interactive state controls and updates via setState', (WidgetTester tester) async {
    // Provide a taller test viewport so all elements render without clipping
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('Live Application State (setState)'), findsOneWidget);
    expect(find.text('Assignment Alerts'), findsOneWidget);
    expect(find.text('English (Default)'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Toggle Dark Mode Switch (triggers setState)
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Dark Theme (Enabled)'), findsOneWidget);

    // Toggle Assignment Alerts Checkbox
    final checkbox = find.widgetWithText(CheckboxListTile, 'Assignment Alerts');
    expect(checkbox, findsOneWidget);
    await tester.tap(checkbox);
    await tester.pump();

    // Verify Save Button works
    await tester.tap(find.text('Save Preferences'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
