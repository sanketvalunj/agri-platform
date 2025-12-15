import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

class CarbonDashboardScreen extends StatelessWidget {
  const CarbonDashboardScreen({Key? key}) : super(key: key);

  // Toggle later with backend
  final bool hasCarbonData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Carbon Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: hasCarbonData ? _buildDashboard(context) : _buildEmptyState(),
      ),

      bottomNavigationBar: const AgriBottomNav(currentIndex: 2),
    );
  }

  /// 🌱 DASHBOARD (Scrollable – NO OVERFLOW)
  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title
          Text(
            'Your Carbon Impact',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'See how your farming helps the environment',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 24),

          // 🌿 Impact Cards
          const ImpactCard(
            icon: Icons.eco,
            title: 'Carbon Score',
            value: '78',
            unit: 'Points',
            backgroundColor: Color(0xFFE8F5E9),
            iconColor: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),

          const ImpactCard(
            icon: Icons.cloud,
            title: 'CO₂ Saved',
            value: '1.2',
            unit: 'Tons',
            backgroundColor: Color(0xFFE3F2FD),
            iconColor: Color(0xFF1565C0),
          ),
          const SizedBox(height: 16),

          const ImpactCard(
            icon: Icons.star,
            title: 'Carbon Credits',
            value: '12',
            unit: 'Credits',
            backgroundColor: Color(0xFFFFF8E1),
            iconColor: Color(0xFFF9A825),
          ),
          const SizedBox(height: 16),

          const ImpactCard(
            icon: Icons.currency_rupee,
            title: 'Estimated Value',
            value: '₹1,200',
            unit: '',
            backgroundColor: Color(0xFFF1F8E9),
            iconColor: Color(0xFF558B2F),
          ),

          const SizedBox(height: 32),

          // 🔁 BEFORE / AFTER COMPARISON (JUDGE WOW)
          Text(
            'Impact Comparison',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: const [
                CompareItem(
                  label: 'Before\nTraditional Practices',
                  value: 'Low',
                  color: Colors.red,
                ),
                Icon(Icons.arrow_forward, size: 28),
                CompareItem(
                  label: 'After\nSustainable Practices',
                  value: 'High',
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 👉 CTA Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.carbonInsights);
              },
              icon: const Icon(Icons.lightbulb_outline, size: 28),
              label: const Text(
                'View Tips to Earn More',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🚫 EMPTY STATE
  Widget _buildEmptyState() {
    return const EmptyState(
      icon: Icons.eco_outlined,
      title: 'No Carbon Data Yet',
      message:
          'Add your farm activities to start earning carbon credits and rewards.',
    );
  }
}

/// 🔁 Before / After Item (SAFE layout)
class CompareItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const CompareItem({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌿 Impact Card
class ImpactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final Color backgroundColor;
  final Color iconColor;

  const ImpactCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: iconColor),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(unit),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
