import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/app_drawer.dart';
import '../services/preferences_service.dart';
import '../dart_concepts.dart';

/// Dashboard Screen: Central responsive hub presenting student metrics, attendance,
/// persistent preferences, BottomNavigationBar, and AppDrawer navigation.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final openDrawerParam = Uri.base.queryParameters['drawer'] == 'true';
    final openLogoutParam = Uri.base.queryParameters['logout'] == 'true';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (openDrawerParam) {
        _scaffoldKey.currentState?.openDrawer();
      } else if (openLogoutParam) {
        _showLogoutDialog(context);
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Confirm Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to end your current session? Your persistent session will be cleared from SharedPreferences.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await PreferencesService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() => _bottomNavIndex = index);
    switch (index) {
      case 0:
        // Already on home / dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/attendance');
        break;
      case 2:
        Navigator.pushNamed(context, '/timetable');
        break;
      case 3:
        Navigator.pushNamed(context, '/notes_tasks');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

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
    final currentUserName = PreferencesService.userName;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(currentRoute: '/dashboard'),
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
            tooltip: 'Settings & Persistent Preferences',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
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
                  Navigator.pushNamed(context, '/notifications');
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
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: isDark ? Colors.white60 : Colors.grey.shade600,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 8,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_rounded),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
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
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  borderRadius: BorderRadius.circular(16),
                  child: Card(
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
                              currentUserName.isNotEmpty
                                  ? currentUserName
                                        .split(' ')
                                        .take(2)
                                        .map((e) => e.isNotEmpty ? e[0] : '')
                                        .join()
                                        .toUpperCase()
                                  : 'PS',
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
                                  currentUserName.isNotEmpty
                                      ? currentUserName
                                      : student.name,
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
                      onTap: () => Navigator.pushNamed(context, '/attendance'),
                    ),
                    DashboardCard(
                      title: 'Timetable',
                      subtitle: 'Monday: 4 Lectures',
                      icon: Icons.schedule,
                      primaryColor: Colors.indigo,
                      badgeText: 'Today',
                      onTap: () => Navigator.pushNamed(context, '/timetable'),
                    ),
                    DashboardCard(
                      title: 'Assignments',
                      subtitle: '3 Submissions Due',
                      icon: Icons.assignment,
                      primaryColor: Colors.deepOrange,
                      badgeText: '3 Due',
                      onTap: () => Navigator.pushNamed(context, '/assignments'),
                    ),
                    DashboardCard(
                      title: 'Notifications',
                      subtitle: '3 Unread Notices',
                      icon: Icons.notifications,
                      primaryColor: Colors.amber.shade800,
                      badgeText: 'Alert',
                      onTap: () =>
                          Navigator.pushNamed(context, '/notifications'),
                    ),
                    DashboardCard(
                      title: 'Faculty Info',
                      subtitle: '4 Professors & HOD',
                      icon: Icons.badge,
                      primaryColor: Colors.cyan.shade800,
                      badgeText: 'Directory',
                      onTap: () => Navigator.pushNamed(context, '/faculty'),
                    ),
                    DashboardCard(
                      title: 'Event Gallery',
                      subtitle: '6 Tech Fests & Summits',
                      icon: Icons.photo_library,
                      primaryColor: Colors.pink,
                      badgeText: 'Events',
                      onTap: () => Navigator.pushNamed(context, '/events'),
                    ),
                    DashboardCard(
                      title: 'Notes & Tasks (P6)',
                      subtitle: 'Offline SQLite Database CRUD',
                      icon: Icons.storage_rounded,
                      primaryColor: Colors.teal.shade700,
                      badgeText: 'SQLite DB',
                      onTap: () => Navigator.pushNamed(context, '/notes_tasks'),
                    ),
                    DashboardCard(
                      title: 'Live Notices (P7)',
                      subtitle: 'RESTful API Integration',
                      icon: Icons.public_rounded,
                      primaryColor: Colors.blue.shade800,
                      badgeText: 'REST API',
                      onTap: () =>
                          Navigator.pushNamed(context, '/live_notices'),
                    ),
                    DashboardCard(
                      title: 'Smart Assistant (P8)',
                      subtitle: 'Google AI Edge & Gemini Nano',
                      icon: Icons.smart_toy_rounded,
                      primaryColor: Colors.deepPurple.shade700,
                      badgeText: 'On-Device AI',
                      onTap: () =>
                          Navigator.pushNamed(context, '/ai_assistant'),
                    ),
                    DashboardCard(
                      title: 'Optimization & Tests (P9)',
                      subtitle: 'DevTools, Profiling & 20 TCs',
                      icon: Icons.speed_rounded,
                      primaryColor: Colors.indigo.shade800,
                      badgeText: 'DevTools P9',
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/performance_dashboard',
                      ),
                    ),
                    DashboardCard(
                      title: 'Production Deploy (P10)',
                      subtitle: 'Keystore, CI/CD & Signed AAB',
                      icon: Icons.rocket_launch_rounded,
                      primaryColor: Colors.teal.shade800,
                      badgeText: 'Release P10',
                      onTap: () =>
                          Navigator.pushNamed(context, '/deployment_readiness'),
                    ),
                    DashboardCard(
                      title: 'Settings & Storage',
                      subtitle: 'Preferences & SharedPreferences',
                      icon: Icons.tune,
                      primaryColor: Colors.deepPurple,
                      badgeText: 'P5 Prefs',
                      onTap: () => Navigator.pushNamed(context, '/settings'),
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
