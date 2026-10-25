import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Reusable application Navigation Drawer providing hierarchical navigation
/// across all modules and persistent session logout management.
class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  void _navigateTo(BuildContext context, String routeName) {
    Navigator.pop(context); // Close drawer first
    if (currentRoute != routeName) {
      if (routeName == '/dashboard') {
        Navigator.pushReplacementNamed(context, routeName);
      } else {
        Navigator.pushNamed(context, routeName);
      }
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    Navigator.pop(context); // Close drawer
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
          'Are you sure you want to sign out? Your persistent session will be cleared from SharedPreferences.',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final userName = PreferencesService.userName;
    final userEmail = PreferencesService.userEmail;

    final initials = userName
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase();

    return Drawer(
      child: Column(
        children: [
          // User Profile Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1F1F1F), const Color(0xFF2C3E50)]
                    : [const Color(0xFF1A237E), const Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                initials.isEmpty ? 'PS' : initials,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFF2C3E50)
                      : const Color(0xFF1A237E),
                ),
              ),
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.how_to_reg_rounded,
                  title: 'Attendance',
                  route: '/attendance',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_month_rounded,
                  title: 'Timetable',
                  route: '/timetable',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.assignment_rounded,
                  title: 'Assignments',
                  route: '/assignments',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people_alt_rounded,
                  title: 'Faculty Directory',
                  route: '/faculty',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.photo_library_rounded,
                  title: 'Event Gallery',
                  route: '/events',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Student Profile',
                  route: '/profile',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.public_rounded,
                  title: 'Live Notices (REST API)',
                  route: '/live_notices',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.smart_toy_rounded,
                  title: 'AI Smart Assistant (P8)',
                  route: '/ai_assistant',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.storage_rounded,
                  title: 'Notes & Tasks (SQLite)',
                  route: '/notes_tasks',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings & Storage',
                  route: '/settings',
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Logout Session',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _showLogoutConfirmation(context),
                ),
              ],
            ),
          ),

          // University Footer Badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              'CHARUSAT FTE • AIUE302 v1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = currentRoute == route;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? primaryColor
            : theme.iconTheme.color?.withValues(alpha: 0.8),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryColor : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: primaryColor.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => _navigateTo(context, route),
    );
  }
}
