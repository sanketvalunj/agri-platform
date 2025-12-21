import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// CarbonInsightsScreen
/// --------------------
/// Purpose:
/// - Empower farmers with simple, actionable steps
/// - Encourage sustainable practices
/// - Judge-friendly impact visualization
///
/// UX Enhancements:
/// - "What You Can Do Today" section
/// - Large tap areas
/// - Clear, non-technical language
/// - Scroll-safe layout
///
/// NOTE:
/// - UI only
/// - Placeholder content
/// - No backend / logic

class CarbonInsightsScreen extends StatelessWidget {
  const CarbonInsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Carbon Tips',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌱 SECTION TITLE
              Text(
                'What You Can Do Today',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Small steps that increase your carbon credits',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 24),

              // 🌿 ACTIONABLE TIPS
              const InsightCard(
                icon: Icons.park,
                message: '🌱 Plant at least 5 trees on your farm',
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Color(0xFF2E7D32),
              ),

              const SizedBox(height: 16),

              const InsightCard(
                icon: Icons.science,
                message: '💧 Reduce chemical fertilizer usage where possible',
                backgroundColor: Color(0xFFFFF8E1),
                iconColor: Color(0xFFF9A825),
              ),

              const SizedBox(height: 16),

              const InsightCard(
                icon: Icons.water,
                message: '🚜 Try drip irrigation to save water and fuel',
                backgroundColor: Color(0xFFE3F2FD),
                iconColor: Color(0xFF1565C0),
              ),

              const SizedBox(height: 16),

              const InsightCard(
                icon: Icons.agriculture,
                message: '🌾 Practice minimum or no-till farming if possible',
                backgroundColor: Color(0xFFF1F8E9),
                iconColor: Color(0xFF558B2F),
              ),
            ],
          ),
        ),
      ),

      // 🧭 Bottom Navigation (Carbon active)
      bottomNavigationBar: const AgriBottomNav(currentIndex: 2),
    );
  }
}

/// InsightCard
/// ------------
/// Large, farmer-friendly actionable card
class InsightCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color backgroundColor;
  final Color iconColor;

  const InsightCard({
    Key? key,
    required this.icon,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
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
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
