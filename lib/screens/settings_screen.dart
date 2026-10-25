import 'package:flutter/material.dart';
import '../models/settings_state.dart';

/// Settings & Preferences Screen: Implements interactive state management using setState()
/// featuring Checkbox, Radio Button, Switch, DropdownButton, and Slider widgets.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Ephemeral State variables managed by setState()
  late StudentSettingsState _state;

  final List<String> _semesters = [
    'Semester I',
    'Semester II',
    'Semester III',
    'Semester IV',
    'Semester V',
    'Semester VI',
    'Semester VII',
    'Semester VIII',
  ];

  final List<String> _allCourses = [
    'Mobile Application Development',
    'Artificial Intelligence',
    'Database Management System',
    'Computer Networks',
  ];

  @override
  void initState() {
    super.initState();
    _state = StudentSettingsState(isDarkMode: AppThemeState.isDarkMode);
  }

  void _savePreferences() {
    // Synchronize global theme
    AppThemeState.toggleTheme(_state.isDarkMode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Settings updated successfully for ${_state.studentName} (${_state.semester})!',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetDefaults() {
    setState(() {
      _state = StudentSettingsState(isDarkMode: false);
      AppThemeState.toggleTheme(false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences reset to default values.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _state.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Defaults',
            onPressed: _resetDefaults,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Settings',
            onPressed: _savePreferences,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Live State Preview Banner
            _buildLiveStateCard(),
            const SizedBox(height: 16),

            // 2. Theme Mode Setting (Switch)
            _buildSectionHeader('Appearance & Theme', Icons.palette_outlined),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                title: Text(
                  isDark ? 'Dark Theme (Enabled)' : 'Light Theme (Active)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isDark
                      ? 'High-contrast dark mode reduces eye strain in low light'
                      : 'Standard bright Material theme for daily daytime use',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: isDark ? Colors.amber : Colors.orange,
                ),
                value: _state.isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _state.isDarkMode = value;
                    AppThemeState.toggleTheme(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. Semester Selection (DropdownButton)
            _buildSectionHeader('Academic Semester Selection', Icons.school_outlined),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Current Semester',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _state.semester,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.calendar_month, color: theme.primaryColor),
                      ),
                      dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      items: _semesters.map((sem) {
                        return DropdownMenuItem<String>(
                          value: sem,
                          child: Text(sem),
                        );
                      }).toList(),
                      onChanged: (String? newSem) {
                        if (newSem != null) {
                          setState(() {
                            _state.semester = newSem;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Language Preference (Radio Buttons wrapped in RadioGroup)
            _buildSectionHeader('Language Preference', Icons.translate),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: RadioGroup<String>(
                groupValue: _state.language,
                onChanged: (val) {
                  if (val != null) setState(() => _state.language = val);
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('English (Default)'),
                      subtitle: Text('Primary language for course curriculum and exams', style: TextStyle(fontSize: 11)),
                      value: 'English',
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      title: Text('Hindi (हिन्दी)'),
                      subtitle: Text('Hindi academic notifications and guidelines', style: TextStyle(fontSize: 11)),
                      value: 'Hindi',
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      title: Text('Gujarati (ગુજરાતી)'),
                      subtitle: Text('Regional language notifications and announcements', style: TextStyle(fontSize: 11)),
                      value: 'Gujarati',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Notification Preferences (Checkboxes)
            _buildSectionHeader('Notification Preferences', Icons.notifications_active_outlined),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Assignment Alerts'),
                    subtitle: const Text('Receive submission deadline reminders and grading notices', style: TextStyle(fontSize: 11)),
                    value: _state.assignmentAlerts,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      setState(() => _state.assignmentAlerts = val ?? false);
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: const Text('Examination Notifications'),
                    subtitle: const Text('Timetable alerts, seat allocations, and result declarations', style: TextStyle(fontSize: 11)),
                    value: _state.examNotifications,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      setState(() => _state.examNotifications = val ?? false);
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: const Text('Placement Updates'),
                    subtitle: const Text('Campus drive announcements and internship interview alerts', style: TextStyle(fontSize: 11)),
                    value: _state.placementUpdates,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      setState(() => _state.placementUpdates = val ?? false);
                    },
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    title: const Text('Event Announcements'),
                    subtitle: const Text('Hackathons, tech fests, workshops, and cultural fests', style: TextStyle(fontSize: 11)),
                    value: _state.eventAnnouncements,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      setState(() => _state.eventAnnouncements = val ?? false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. Daily Study Goal Target (Slider)
            _buildSectionHeader('Daily Study Target Goal', Icons.timer_outlined),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Target Daily Study Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_state.dailyStudyGoalHours.toStringAsFixed(1)} Hours/Day',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _state.dailyStudyGoalHours,
                      min: 1.0,
                      max: 8.0,
                      divisions: 14,
                      activeColor: theme.primaryColor,
                      label: '${_state.dailyStudyGoalHours.toStringAsFixed(1)} hrs',
                      onChanged: (double newVal) {
                        setState(() {
                          _state.dailyStudyGoalHours = newVal;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1.0 hr (Light)', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        Text('4.5 hrs (Standard)', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        Text('8.0 hrs (Intensive)', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 7. Course Preferences (Filter Chips)
            _buildSectionHeader('Course Preferences & Enrolment', Icons.menu_book),
            Card(
              elevation: 2,
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap to select preferred subjects to highlight on the dashboard:',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allCourses.map((course) {
                        final isSelected = _state.selectedCourses.contains(course);
                        return FilterChip(
                          label: Text(course),
                          selected: isSelected,
                          selectedColor: theme.primaryColor.withValues(alpha: 0.2),
                          checkmarkColor: theme.primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? theme.primaryColor : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _state.selectedCourses.add(course);
                              } else {
                                if (_state.selectedCourses.length > 1) {
                                  _state.selectedCourses.remove(course);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save & Reset Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetDefaults,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _savePreferences,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Save Preferences', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStateCard() {
    final theme = Theme.of(context);
    final isDark = _state.isDarkMode;

    int activeNotifs = 0;
    if (_state.assignmentAlerts) activeNotifs++;
    if (_state.examNotifications) activeNotifs++;
    if (_state.placementUpdates) activeNotifs++;
    if (_state.eventAnnouncements) activeNotifs++;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF2C3E50), const Color(0xFF000000)]
                : [theme.primaryColor, const Color(0xFF3949AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.amberAccent, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Live Application State (setState)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isDark ? 'Dark Mode' : 'Light Mode',
                    style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLiveParam('Semester', _state.semester),
                _buildLiveParam('Language', _state.language),
                _buildLiveParam('Study Target', '${_state.dailyStudyGoalHours.toStringAsFixed(1)}h'),
                _buildLiveParam('Notifs', '$activeNotifs Active'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Enrolled: ${_state.selectedCourses.length} Courses Selected',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveParam(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
