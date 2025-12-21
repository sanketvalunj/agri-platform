import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// SettingsScreen
/// --------------
/// Purpose:
/// - Allow farmers to manage basic app preferences
/// - Keep everything simple and safe
///
/// UX Principles:
/// - Large tap areas
/// - Clear labels
/// - No technical terms
///
/// NOTE:
/// - UI only
/// - No backend logic

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 👤 Profile
            SettingsTile(
              icon: Icons.person,
              title: 'Farm Profile',
              subtitle: 'View or update your farm details',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.farmProfile);
              },
            ),

            const SizedBox(height: 12),

            // 🌐 Language
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Change app language',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.language);
              },
            ),

            const SizedBox(height: 12),

            // 📍 Location
            SettingsTile(
              icon: Icons.location_on,
              title: 'Location',
              subtitle: 'Update your farm location',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.location);
              },
            ),

            const SizedBox(height: 12),

            // 🔔 Notifications (UI only)
            SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage alerts and reminders',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings coming soon'),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ❓ Help
            SettingsTile(
              icon: Icons.help_outline,
              title: 'Help & How It Works',
              subtitle: 'Understand how Agri Bot helps you',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.help);
              },
            ),

            const SizedBox(height: 32),

            // 🚪 Logout (UI only)
            SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Exit the app safely',
              iconColor: Colors.red,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout functionality coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // 🟢 Bottom Navigation
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }
}

/// 🔹 Reusable Settings Tile
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.green.shade700).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor ?? Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
