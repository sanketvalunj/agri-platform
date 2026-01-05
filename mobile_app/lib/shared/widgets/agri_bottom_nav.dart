import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

/// AgriBottomNav
/// --------------
/// Purpose:
/// - Persistent navigation for farmers
/// - Simple, predictable, one-tap access
/// - Prevents confusion & backstack issues
///
/// Tabs (FINAL):
/// 0 → Home
/// 1 → Weather
/// 2 → Chat
/// 3 → Community
/// 4 → Alerts
///
/// UX Principles:
/// - Large icons
/// - Clear labels
/// - High contrast
/// - Safe navigation using pushReplacement

class AgriBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AgriBottomNav({super.key, required this.currentIndex, this.onTap});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    if (onTap != null) {
      onTap!(index);
      return;
    }

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.weather);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.chatbot);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.community);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.alerts);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onTap(context, i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Weather'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Alerts'),
      ],
    );
  }
}
