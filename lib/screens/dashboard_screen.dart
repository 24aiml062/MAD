import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/dashboard_card.dart';
import '../dart_concepts.dart';
import 'attendance_screen.dart';
import 'timetable_screen.dart';
import 'assignments_screen.dart';
import 'notifications_screen.dart';
import 'faculty_screen.dart';
import 'event_gallery_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Dashboard Screen: Central responsive hub presenting student metrics, attendance, and academic feature modules.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _showModuleDialog(
    BuildContext context,
    String title,
    String description,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.indigo),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const student = StudentModel.currentStudent;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Settings Action
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            tooltip: 'Settings & Preferences',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          // Notification Bell with Unread Badge (Stack widget)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 26),
                tooltip: 'Notifications',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Student Profile Action
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            tooltip: 'My Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTabletOrDesktop = constraints.maxWidth >= 650;
          final int gridColumns = isTabletOrDesktop ? 4 : 2;
          final double gridAspectRatio = isTabletOrDesktop ? 1.25 : 1.15;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Student Overview Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white,
                          child: Text(
                            'PS',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Roll No: ${student.enrollmentNo}  |  ${student.semester}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified,
                                      size: 14,
                                      color: Colors.greenAccent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Attendance: ${student.attendancePercentage.toInt()}% (Eligible)',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Academic Stats Row
                Row(
                  children: [
                    _buildQuickStat(
                      'CGPA',
                      '8.75',
                      Icons.grade,
                      Colors.amber.shade700,
                      context,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickStat(
                      'Subjects',
                      '4 Enrolled',
                      Icons.book_outlined,
                      Colors.blue,
                      context,
                    ),
                    const SizedBox(width: 10),
                    _buildQuickStat(
                      'Tasks',
                      '3 Pending',
                      Icons.task_alt,
                      Colors.deepOrange,
                      context,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Academic Feature Modules',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '$gridColumns-Column Responsive Layout',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Responsive Grid of Feature Modules
                GridView.count(
                  crossAxisCount: gridColumns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: gridAspectRatio,
                  children: [
                    DashboardCard(
                      title: 'Attendance',
                      subtitle: 'Overall: 91% (Safe)',
                      icon: Icons.how_to_reg,
                      primaryColor: Colors.teal,
                      badgeText: '91%',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AttendanceScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Timetable',
                      subtitle: 'Monday: 4 Lectures',
                      icon: Icons.schedule,
                      primaryColor: Colors.indigo,
                      badgeText: 'Today',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TimetableScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Assignments',
                      subtitle: '3 Submissions Due',
                      icon: Icons.assignment,
                      primaryColor: Colors.deepOrange,
                      badgeText: '3 Due',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AssignmentsScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Notifications',
                      subtitle: '3 Unread Notices',
                      icon: Icons.notifications,
                      primaryColor: Colors.amber.shade800,
                      badgeText: 'Alert',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Faculty Info',
                      subtitle: '4 Professors & HOD',
                      icon: Icons.badge,
                      primaryColor: Colors.cyan.shade800,
                      badgeText: 'Directory',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FacultyScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Event Gallery',
                      subtitle: '6 Tech Fests & Summits',
                      icon: Icons.photo_library,
                      primaryColor: Colors.pink,
                      badgeText: 'Events',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventGalleryScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Settings (P4)',
                      subtitle: 'State Management Lab',
                      icon: Icons.tune,
                      primaryColor: Colors.deepPurple,
                      badgeText: 'setState',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    DashboardCard(
                      title: 'Dart Lab Concepts',
                      subtitle: 'Practical 1 Fundamentals',
                      icon: Icons.code,
                      primaryColor: Colors.purple,
                      badgeText: 'P1 Demo',
                      onTap: () {
                        demonstrateDartConcepts();
                        _showModuleDialog(
                          context,
                          'Dart Concepts Verification',
                          'Dart OOP & fundamentals executed in debug console!\n\nCovered:\n• Variables, Types, Operators\n• Loops & Conditionals\n• Functions & Classes\n• Inheritance & Encapsulation',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
