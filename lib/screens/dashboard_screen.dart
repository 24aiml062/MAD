import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/dashboard_card.dart';
import '../dart_concepts.dart';
import 'profile_screen.dart';

/// Dashboard Screen: Central hub presenting student metrics, attendance, and feature modules.
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Notification Bell with Unread Badge (Stack widget)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 26),
                tooltip: 'Notifications',
                onPressed: () {
                  _showModuleDialog(
                    context,
                    'Academic Notifications',
                    '• MAD Assignment 2 submission: Oct 28\n• AI Workshop Registration Open\n• Mid-Sem Exam Timetable published',
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
      body: SingleChildScrollView(
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
                ),
                const SizedBox(width: 10),
                _buildQuickStat(
                  'Subjects',
                  '4 Enrolled',
                  Icons.book_outlined,
                  Colors.blue,
                ),
                const SizedBox(width: 10),
                _buildQuickStat(
                  'Tasks',
                  '3 Pending',
                  Icons.task_alt,
                  Colors.deepOrange,
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
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  '8 Modules',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grid of Modules
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                DashboardCard(
                  title: 'Attendance',
                  subtitle: 'Overall: 91% (Safe)',
                  icon: Icons.how_to_reg,
                  primaryColor: Colors.teal,
                  badgeText: '91%',
                  onTap: () => _showModuleDialog(
                    context,
                    'Attendance Breakdown',
                    '• MAD: 88%\n• DBMS: 92%\n• AI: 95%\n• CN: 90%\n\nOverall Attendance: 91% (Meets criteria)',
                  ),
                ),
                DashboardCard(
                  title: 'Timetable',
                  subtitle: 'Monday: 4 Lectures',
                  icon: Icons.schedule,
                  primaryColor: Colors.indigo,
                  badgeText: 'Today',
                  onTap: () => _showModuleDialog(
                    context,
                    "Today's Schedule",
                    '09:00 - 10:00: MAD Lecture\n10:15 - 11:15: DBMS Theory\n11:30 - 01:30: AI Lab\n02:15 - 03:15: CN Theory',
                  ),
                ),
                DashboardCard(
                  title: 'Assignments',
                  subtitle: '3 Submissions Due',
                  icon: Icons.assignment,
                  primaryColor: Colors.deepOrange,
                  badgeText: '3 Due',
                  onTap: () => _showModuleDialog(
                    context,
                    'Pending Assignments',
                    '1. Practical 2 UI Design (Due Oct 28)\n2. DBMS SQL Queries (Due Nov 02)\n3. AI Search Algorithms (Due Nov 05)',
                  ),
                ),
                DashboardCard(
                  title: 'Notes & Material',
                  subtitle: '4 Subjects Available',
                  icon: Icons.menu_book,
                  primaryColor: Colors.purple,
                  onTap: () => _showModuleDialog(
                    context,
                    'Course Materials',
                    '• MAD: Flutter Widgets & Layout Notes\n• DBMS: Normalization Slides\n• AI: Search Space Graphs\n• CN: OSI Reference Model',
                  ),
                ),
                DashboardCard(
                  title: 'Events & Alerts',
                  subtitle: 'CHARUSAT Tech Fest',
                  icon: Icons.celebration,
                  primaryColor: Colors.pink,
                  badgeText: 'New',
                  onTap: () => _showModuleDialog(
                    context,
                    'University Events',
                    '• Annual National Hackathon: Nov 15\n• AI Summit 2026: Nov 20\n• Cultural Evening: Dec 01',
                  ),
                ),
                DashboardCard(
                  title: 'Notifications',
                  subtitle: '3 Unread Notices',
                  icon: Icons.notifications,
                  primaryColor: Colors.amber.shade800,
                  badgeText: 'Alert',
                  onTap: () => _showModuleDialog(
                    context,
                    'Notice Board',
                    '• Mid-Sem dates declared: Dec 10 onwards\n• Library book renewal due date: Oct 30\n• Fee receipt generation available',
                  ),
                ),
                DashboardCard(
                  title: 'Student Profile',
                  subtitle: 'View Academic Record',
                  icon: Icons.person_search,
                  primaryColor: Colors.blueGrey,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                DashboardCard(
                  title: 'Dart Lab Concepts',
                  subtitle: 'Practical 1 Fundamentals',
                  icon: Icons.code,
                  primaryColor: Colors.cyan.shade800,
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
      ),
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
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
