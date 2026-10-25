import 'package:flutter/material.dart';

/// App theme state notifier allowing dynamic Light/Dark mode switching across the app.
class AppThemeState {
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  static void toggleTheme(bool dark) {
    themeModeNotifier.value = dark ? ThemeMode.dark : ThemeMode.light;
  }
}

/// Data model representing student settings and preferences state.
class StudentSettingsState {
  String studentName;
  String semester;
  String language;
  bool isDarkMode;
  bool assignmentAlerts;
  bool examNotifications;
  bool placementUpdates;
  bool eventAnnouncements;
  double dailyStudyGoalHours;
  List<String> selectedCourses;

  StudentSettingsState({
    this.studentName = 'Parita Shah',
    this.semester = 'Semester V',
    this.language = 'English',
    this.isDarkMode = false,
    this.assignmentAlerts = true,
    this.examNotifications = true,
    this.placementUpdates = false,
    this.eventAnnouncements = true,
    this.dailyStudyGoalHours = 3.5,
    List<String>? selectedCourses,
  }) : selectedCourses =
           selectedCourses ??
           [
             'Mobile Application Development',
             'Artificial Intelligence',
             'Database Management System',
             'Computer Networks',
           ];

  StudentSettingsState copy() {
    return StudentSettingsState(
      studentName: studentName,
      semester: semester,
      language: language,
      isDarkMode: isDarkMode,
      assignmentAlerts: assignmentAlerts,
      examNotifications: examNotifications,
      placementUpdates: placementUpdates,
      eventAnnouncements: eventAnnouncements,
      dailyStudyGoalHours: dailyStudyGoalHours,
      selectedCourses: List.from(selectedCourses),
    );
  }
}
