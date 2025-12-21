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
/// 1 → Ask Agri Bot
/// 2 → Market Prices
/// 3 → Carbon Impact
///
/// UX Principles:
/// - Large icons
/// - Clear labels
/// - High contrast
/// - Safe navigation using pushReplacement

class AgriBottomNav extends StatelessWidget {
  final int currentIndex;

  const AgriBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.chatbot);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.market);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.carbonOverview);
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
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Ask'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Market'),
        BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Carbon'),
      ],
    );
  }
}
