import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_state.dart';

/// Centralized service managing persistent user preferences, session state,
/// and application configuration using the shared_preferences package.
class PreferencesService {
  static SharedPreferences? _prefs;

  // Storage Keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keySemester = 'user_semester';
  static const String _keyLanguage = 'user_language';
  static const String _keyDarkMode = 'user_dark_mode';
  static const String _keyStudyGoal = 'user_study_goal';
  static const String _keyNotifyAssignments = 'notify_assignments';
  static const String _keyNotifyExams = 'notify_exams';
  static const String _keyNotifyPlacements = 'notify_placements';
  static const String _keyNotifyEvents = 'notify_events';
  static const String _keyPreferredCourses = 'preferred_courses';
  static const String _keyLastLoginTimestamp = 'last_login_timestamp';

  /// Initializes the SharedPreferences instance.
  static Future<SharedPreferences> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Synchronous accessor for prefs after initialization.
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw StateError(
        'PreferencesService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  // --- Session Management ---

  /// Checks if the user is currently authenticated with an active session.
  static bool get isLoggedIn => _prefs?.getBool(_keyIsLoggedIn) ?? false;

  /// Retrieves the saved user email address.
  static String get userEmail =>
      _prefs?.getString(_keyUserEmail) ?? '24aiml062@charusat.edu.in';

  /// Retrieves the saved student name.
  static String get userName =>
      _prefs?.getString(_keyUserName) ?? 'Parita Shah';

  /// Performs user login and persists authentication state.
  static Future<bool> login({
    required String email,
    required String password,
    String name = 'Parita Shah',
  }) async {
    final prefs = await init();
    // Accept syllabus sample user (rahul.patel@charusat.edu.in) or student credentials
    final validSyllabus =
        email == 'rahul.patel@charusat.edu.in' && password == 'student@123';
    final validStudent = email.isNotEmpty && password.length >= 6;

    if (validSyllabus || validStudent) {
      final displayName = validSyllabus ? 'Rahul Patel' : name;
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserName, displayName);
      await prefs.setInt(
        _keyLastLoginTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    }
    return false;
  }

  /// Clears stored user session credentials upon logout.
  static Future<void> logout() async {
    final prefs = await init();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyLastLoginTimestamp);
  }

  // --- Preference Settings Persistence ---

  /// Saves the complete StudentSettingsState to SharedPreferences.
  static Future<void> saveSettings(StudentSettingsState state) async {
    final prefs = await init();
    await prefs.setBool(_keyDarkMode, state.isDarkMode);
    await prefs.setString(_keySemester, state.semester);
    await prefs.setString(_keyLanguage, state.language);
    await prefs.setDouble(_keyStudyGoal, state.dailyStudyGoalHours);
    await prefs.setBool(_keyNotifyAssignments, state.assignmentAlerts);
    await prefs.setBool(_keyNotifyExams, state.examNotifications);
    await prefs.setBool(_keyNotifyPlacements, state.placementUpdates);
    await prefs.setBool(_keyNotifyEvents, state.eventAnnouncements);
    await prefs.setStringList(_keyPreferredCourses, state.selectedCourses);
  }

  /// Loads saved settings from SharedPreferences, falling back to defaults.
  static StudentSettingsState loadSettings() {
    if (_prefs == null) {
      return StudentSettingsState();
    }
    return StudentSettingsState(
      studentName: userName,
      isDarkMode: _prefs!.getBool(_keyDarkMode) ?? false,
      semester: _prefs!.getString(_keySemester) ?? 'Semester V',
      language: _prefs!.getString(_keyLanguage) ?? 'English',
      dailyStudyGoalHours: _prefs!.getDouble(_keyStudyGoal) ?? 3.5,
      assignmentAlerts: _prefs!.getBool(_keyNotifyAssignments) ?? true,
      examNotifications: _prefs!.getBool(_keyNotifyExams) ?? true,
      placementUpdates: _prefs!.getBool(_keyNotifyPlacements) ?? false,
      eventAnnouncements: _prefs!.getBool(_keyNotifyEvents) ?? true,
      selectedCourses:
          _prefs!.getStringList(_keyPreferredCourses) ??
          [
            'Mobile Application Development',
            'Artificial Intelligence',
            'Database Management System',
            'Computer Networks',
          ],
    );
  }

  /// Retrieves persisted dark mode preference.
  static bool getSavedThemeMode() {
    return _prefs?.getBool(_keyDarkMode) ?? false;
  }

  /// Persists dark mode preference.
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await init();
    await prefs.setBool(_keyDarkMode, isDark);
  }
}
