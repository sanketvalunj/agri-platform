import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// CarbonOverviewScreen
/// --------------------
/// Purpose:
/// - Entry point to Carbon Credit module
/// - Clear next steps for farmers
///
/// UX Principles:
/// - Simple language
/// - Large buttons
/// - Clear flow
/// - Bottom navigation safety
///
/// NOTE:
/// - UI only
/// - No backend logic

class CarbonOverviewScreen extends StatelessWidget {
  const CarbonOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Carbon Credits',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'Alerts',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.alerts);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌱 Header
              Text(
                'Your Carbon Credits',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 10),

              Text(
                'Track how your farming helps the environment and earns rewards',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade800,
                    ),
              ),

              const SizedBox(height: 40),

              // ➕ Add / Update Activity
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.carbonInput);
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                  label: const Text(
                    'Add / Update Farm Activity',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📊 View Dashboard
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.carbonDashboard);
                  },
                  icon: Icon(
                    Icons.bar_chart,
                    size: 28,
                    color: Colors.green.shade800,
                  ),
                  label: Text(
                    'View Carbon Dashboard',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.green.shade700,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // 🔐 Trust Note (VERY IMPORTANT for farmers)
              Text(
                'Carbon credits are estimated based on your farming practices.\nNo penalties — only rewards.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
        ),
      ),

      // 🟢 Bottom Navigation (Carbon Active)
      bottomNavigationBar: const AgriBottomNav(currentIndex: 3),
    );
  }
}
