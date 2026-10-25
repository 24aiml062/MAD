import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_student_companion/main.dart';
import 'package:smart_student_companion/services/preferences_service.dart';
import 'package:smart_student_companion/widgets/app_drawer.dart';
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
import 'package:smart_student_companion/screens/notes_tasks_screen.dart';
import 'package:smart_student_companion/screens/live_notices_screen.dart';
import 'package:smart_student_companion/screens/ai_assistant_screen.dart';
import 'package:smart_student_companion/services/ai_assistant_service.dart';
import 'package:smart_student_companion/models/ai_message.dart';
import 'package:smart_student_companion/services/api_service.dart';
import 'package:smart_student_companion/models/academic_notice.dart';
import 'package:smart_student_companion/services/database_helper.dart';
import 'package:smart_student_companion/models/student_note.dart';
import 'package:smart_student_companion/models/task_item.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'is_logged_in': false,
      'user_name': 'Parita Shah',
      'user_email': '24aiml062@charusat.edu.in',
    });
  });
  testWidgets(
    'Splash Screen renders university branding and progress indicator',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SmartStudentCompanionApp());
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
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, '');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Please enter your student ID or email'), findsOneWidget);
  });

  testWidgets('Dashboard Screen renders student information and module cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Attendance'), findsAtLeastNWidgets(1));
    expect(find.text('Timetable'), findsAtLeastNWidgets(1));
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Event Gallery'), findsOneWidget);
  });

  testWidgets('Profile Screen displays academic stats and university details', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Parita Shah'), findsOneWidget);
    expect(find.text('Roll No: 24AIML062'), findsOneWidget);
    expect(find.text('8.75'), findsOneWidget);
    expect(find.text('Log Out of Account'), findsOneWidget);
  });

  testWidgets(
    'Attendance Screen renders overall percentage and subject progress',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AttendanceScreen()));
      expect(find.text('Attendance Summary'), findsOneWidget);
      expect(find.text('91%'), findsOneWidget);
      expect(find.text('Mobile Application Development (MAD)'), findsOneWidget);
      expect(find.text('Database Management Systems (DBMS)'), findsOneWidget);
    },
  );

  testWidgets('Timetable Screen renders day selector and lecture schedule', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TimetableScreen()));
    expect(find.text('Class Timetable'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Mobile Application Development (MAD)'), findsOneWidget);
  });

  testWidgets('Assignments Screen renders priority chips and due dates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AssignmentsScreen()));
    expect(find.text('Academic Assignments'), findsOneWidget);
    expect(find.text('High Priority'), findsOneWidget);
    expect(
      find.text('Practical 3: Responsive UI & Layout Design'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Notifications Screen renders alert categories and announcements',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: NotificationsScreen()));
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Mid-Semester Internal Exam Schedule'), findsOneWidget);
    },
  );

  testWidgets(
    'Faculty Screen renders professor directory and department info',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FacultyScreen()));
      expect(find.text('Faculty Information'), findsOneWidget);
      expect(find.text('Prof. Jayesh Sharma'), findsOneWidget);
      expect(find.text('Dr. Priya Joshi'), findsOneWidget);
    },
  );

  testWidgets(
    'Event Gallery Screen renders responsive grid of 6 campus events',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: EventGalleryScreen()));
      expect(find.text('Event Gallery'), findsOneWidget);
      expect(find.text('National AI & Mobile Hackathon'), findsOneWidget);
      expect(find.text('AI & Edge Computing Summit'), findsOneWidget);
    },
  );

  testWidgets(
    'Settings Screen renders interactive state controls and updates via setState',
    (WidgetTester tester) async {
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
      final checkbox = find.widgetWithText(
        CheckboxListTile,
        'Assignment Alerts',
      );
      expect(checkbox, findsOneWidget);
      await tester.tap(checkbox);
      await tester.pump();

      // Verify Save Button works
      await tester.tap(find.text('Save Preferences'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );

  testWidgets(
    'Navigation Drawer and BottomNavigationBar render and function properly',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Tasks'), findsAtLeastNWidgets(1));

      // Open Navigation Drawer via scaffold appbar icon
      final scaffoldFinder = find.byType(Scaffold);
      final ScaffoldState scaffoldState = tester.state(scaffoldFinder);
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byType(AppDrawer), findsOneWidget);
      expect(find.text('Faculty Directory'), findsOneWidget);
      expect(find.text('Settings & Storage'), findsAtLeastNWidgets(1));
      expect(find.text('Logout Session'), findsOneWidget);
    },
  );

  test(
    'PreferencesService persists login credentials, session, and settings',
    () async {
      SharedPreferences.setMockInitialValues({});
      await PreferencesService.init();

      expect(PreferencesService.isLoggedIn, isFalse);

      // Test Login with Syllabus test credentials
      final loginSuccess = await PreferencesService.login(
        email: 'rahul.patel@charusat.edu.in',
        password: 'student@123',
      );
      expect(loginSuccess, isTrue);
      expect(PreferencesService.isLoggedIn, isTrue);
      expect(PreferencesService.userName, equals('Rahul Patel'));
      expect(
        PreferencesService.userEmail,
        equals('rahul.patel@charusat.edu.in'),
      );

      // Test Logout
      await PreferencesService.logout();
      expect(PreferencesService.isLoggedIn, isFalse);
    },
  );

  testWidgets('Notes & Tasks Screen renders tabs, notes, and task lists', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MaterialApp(home: NotesTasksScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Notes & Tasks (SQLite DB)'), findsOneWidget);
    expect(find.text('Student Notes'), findsOneWidget);
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.text('Flutter Widgets'), findsOneWidget);

    // Switch to Task Manager Tab
    await tester.tap(find.text('Task Manager'));
    await tester.pumpAndSettle();

    expect(find.text('Submit Flutter Assignment'), findsOneWidget);
    expect(find.text('Prepare DBMS Practical'), findsOneWidget);
  });

  test(
    'DatabaseHelper performs full CRUD operations on notes and tasks',
    () async {
      final dbHelper = DatabaseHelper.instance;

      // 1. CREATE Note
      final noteId = await dbHelper.insertNote(
        const StudentNote(
          title: 'Test SQLite Note',
          description: 'Verifying automated CRUD operations.',
          subject: 'Mobile Application Development',
          createdDate: '2026-10-25',
        ),
      );
      expect(noteId, isPositive);

      // 2. READ Note
      final notes = await dbHelper.getAllNotes(searchQuery: 'Test SQLite Note');
      expect(notes.any((n) => n.title == 'Test SQLite Note'), isTrue);

      // 3. UPDATE Note
      final noteToUpdate = notes.firstWhere(
        (n) => n.title == 'Test SQLite Note',
      );
      await dbHelper.updateNote(
        noteToUpdate.copyWith(title: 'Updated SQLite Note'),
      );
      final updatedNotes = await dbHelper.getAllNotes(
        searchQuery: 'Updated SQLite Note',
      );
      expect(updatedNotes.any((n) => n.title == 'Updated SQLite Note'), isTrue);

      // 4. DELETE Note
      await dbHelper.deleteNote(noteToUpdate.id!);
      final remainingNotes = await dbHelper.getAllNotes(
        searchQuery: 'Updated SQLite Note',
      );
      expect(remainingNotes.isEmpty, isTrue);

      // 5. TASK CRUD
      final taskId = await dbHelper.insertTask(
        const TaskItem(
          taskName: 'Test SQLite Task',
          dueDate: 'Tomorrow',
          priority: 'High',
          status: 'Pending',
        ),
      );
      expect(taskId, isPositive);

      await dbHelper.toggleTaskStatus(taskId, true);
      final tasks = await dbHelper.getAllTasks(searchQuery: 'Test SQLite Task');
      expect(tasks.first.status, equals('Completed'));

      await dbHelper.deleteTask(taskId);
      final remainingTasks = await dbHelper.getAllTasks(
        searchQuery: 'Test SQLite Task',
      );
      expect(remainingTasks.isEmpty, isTrue);
    },
  );

  testWidgets(
    'Live Notices Screen renders REST API notices, tabs, and filters',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: LiveNoticesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('University Notices (REST API)'), findsOneWidget);
      expect(find.text('Live Notices (GET)'), findsOneWidget);
      expect(find.text('Submit Inquiry (POST)'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Exam'), findsOneWidget);

      // Switch to Submit Inquiry Tab
      await tester.tap(find.text('Submit Inquiry (POST)'));
      await tester.pumpAndSettle();

      expect(find.text('Submit Academic Inquiry / Feedback'), findsOneWidget);
      expect(find.text('Send via REST POST Request'), findsOneWidget);
    },
  );

  test(
    'ApiService fetches notices and submits POST feedback successfully',
    () async {
      final notices = await ApiService.getAcademicNotices();
      expect(notices.isNotEmpty, isTrue);
      expect(notices.first.id, isPositive);
      expect(notices.first.title.isNotEmpty, isTrue);
      expect(notices.first.category.isNotEmpty, isTrue);

      final postResult = await ApiService.submitFeedback(
        const StudentFeedbackSubmission(
          studentName: 'Parita Shah',
          email: '24aiml062@charusat.edu.in',
          category: 'Lab Support',
          message: 'Practical 7 REST API submission testing.',
        ),
      );
      expect(postResult['id'], isNotNull);
    },
  );

  test(
    'AiAssistantService generates summaries, study plans, and translations',
    () async {
      final aiService = AiAssistantService();

      // 1. Lecture Notes Summarization
      final summary = await aiService.generateResponse(
        prompt: 'Summarize today\'s lecture on Flutter Widgets',
        category: AiPromptCategory.summarize,
      );
      expect(summary.text, contains('Lecture Summary: Flutter Widgets'));
      expect(summary.isOffline, isTrue);
      expect(summary.processingTimeMs, isPositive);

      // 2. Exam Study Plan
      final studyPlan = await aiService.generateResponse(
        prompt: 'Generate exam study plan for AIUE302',
        category: AiPromptCategory.studyPlan,
      );
      expect(studyPlan.text, contains('5-Day Exam Revision Plan'));

      // 3. Multilingual Translation (Hindi/Gujarati)
      final translation = await aiService.generateResponse(
        prompt: 'Translate mobile AI concepts to Hindi and Gujarati',
        category: AiPromptCategory.translate,
      );
      expect(translation.text, contains('Hindi (हिंदी) Translation'));
      expect(translation.text, contains('Gujarati (ગુજરાતી) Translation'));

      // 4. Academic Q&A
      final qa = await aiService.generateResponse(
        prompt: 'Explain Stateful vs Stateless Widget',
        category: AiPromptCategory.qa,
      );
      expect(qa.text, contains('StatelessWidget'));
      expect(qa.text, contains('StatefulWidget'));
    },
  );

  testWidgets(
    'AiAssistantScreen renders chat UI, prompt chips, and specs dialog',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(home: AiAssistantScreen()));
      await tester.pumpAndSettle();

      expect(find.text('AI Smart Assistant'), findsOneWidget);
      expect(find.text('Gemini Nano • Google AI Edge SDK'), findsOneWidget);
      expect(find.text('Summarize Notes'), findsWidgets);
      expect(find.text('Exam Study Plan'), findsWidgets);

      // Tap Specs Info Action
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      expect(find.text('Gemini Nano Specs'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Tap Quick Action Chip to trigger inference
      await tester.tap(find.text('Summarize Notes').first);
      await tester.pump(); // Start processing
      expect(
        find.text('Gemini Nano executing local on-device inference...'),
        findsOneWidget,
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(
        find.textContaining('Lecture Summary: Flutter Widgets'),
        findsOneWidget,
      );
    },
  );
}
