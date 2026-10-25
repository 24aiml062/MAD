import 'package:flutter/material.dart';
import 'models/settings_state.dart';
import 'services/preferences_service.dart';
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
import 'screens/settings_screen.dart';
import 'screens/notes_tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();

  final darkParam = Uri.base.queryParameters['dark'] == 'true';
  final savedDark = PreferencesService.getSavedThemeMode();
  if (darkParam || savedDark) {
    AppThemeState.toggleTheme(true);
  }
  runApp(const SmartStudentCompanionApp());
}

/// Root widget of the Smart Student Companion App with dynamic theme state management,
/// named routing, and smooth custom page transitions.
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
      case 'settings':
        return const SettingsScreen();
      case 'notes_tasks':
        return const NotesTasksScreen();
      default:
        return const SplashScreen();
    }
  }

  /// Custom animated page route builder providing smooth slide and fade transitions.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/splash':
        page = const SplashScreen();
        break;
      case '/login':
        page = const LoginScreen();
        break;
      case '/register':
        page = const RegistrationScreen();
        break;
      case '/dashboard':
        page = const DashboardScreen();
        break;
      case '/profile':
        page = const ProfileScreen();
        break;
      case '/attendance':
        page = const AttendanceScreen();
        break;
      case '/timetable':
        page = const TimetableScreen();
        break;
      case '/assignments':
        page = const AssignmentsScreen();
        break;
      case '/notifications':
        page = const NotificationsScreen();
        break;
      case '/faculty':
        page = const FacultyScreen();
        break;
      case '/events':
        page = const EventGalleryScreen();
        break;
      case '/settings':
        page = const SettingsScreen();
        break;
      case '/notes_tasks':
        page = const NotesTasksScreen();
        break;
      default:
        page = const SplashScreen();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        );

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeState.themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'Smart Student Companion',
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          // Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: const Color(0xFF1A237E), // Deep Navy
              primary: const Color(0xFF1A237E),
              secondary: const Color(0xFF00897B),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey.shade50,
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          ),
          // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color(0xFF3949AB),
              primary: const Color(0xFF3949AB),
              secondary: const Color(0xFF26A69A),
              surface: const Color(0xFF1E1E1E),
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          home: _getInitialScreen(),
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
