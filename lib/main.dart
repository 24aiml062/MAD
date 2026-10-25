import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/faculty_screen.dart';
import 'screens/event_gallery_screen.dart';

void main() {
  runApp(const SmartStudentCompanionApp());
}

/// Root widget of the Smart Student Companion App.
class SmartStudentCompanionApp extends StatelessWidget {
  const SmartStudentCompanionApp({super.key});

  Widget _getInitialScreen() {
    final screen = Uri.base.queryParameters['screen'];
    switch (screen) {
      case 'login':
        return const LoginScreen();
      case 'register':
        return const RegistrationScreen();
      case 'dashboard':
        return const DashboardScreen();
      case 'profile':
        return const ProfileScreen();
      case 'attendance':
        return const AttendanceScreen();
      case 'timetable':
        return const TimetableScreen();
      case 'assignments':
        return const AssignmentsScreen();
      case 'notifications':
        return const NotificationsScreen();
      case 'faculty':
        return const FacultyScreen();
      case 'events':
        return const EventGalleryScreen();
      default:
        return const SplashScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Deep Navy
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF00897B),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: _getInitialScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/timetable': (context) => const TimetableScreen(),
        '/assignments': (context) => const AssignmentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/faculty': (context) => const FacultyScreen(),
        '/events': (context) => const EventGalleryScreen(),
      },
    );
  }
}
