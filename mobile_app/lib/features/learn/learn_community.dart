import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

class LearnCommunityScreen extends StatelessWidget {
  const LearnCommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Learn & Community',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          key: const ValueKey('learn'),
          padding: const EdgeInsets.all(20),
          children: [
            // 🎓 LEARN SECTION
            const Text(
              'Quick Learn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  LearnCard(
                    title: 'Increase Yield',
                    subtitle: '5 easy steps',
                    icon: Icons.trending_up,
                    gradient: [Color(0xFF66BB6A), Color(0xFF43A047)],
                  ),
                  LearnCard(
                    title: 'Save Water',
                    subtitle: 'Smart irrigation',
                    icon: Icons.water_drop,
                    gradient: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                  ),
                  LearnCard(
                    title: 'Fertilizer Guide',
                    subtitle: 'Correct usage',
                    icon: Icons.science,
                    gradient: [Color(0xFFFFB74D), Color(0xFFF57C00)],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🌾 COMMUNITY SECTION
            const Text(
              'Community & Schemes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const CommunityCard(
              icon: Icons.emoji_events,
              title: 'Farmer Success Story',
              message:
                  'Ramesh from Nashik increased yield by 30% using crop rotation.',
              color: Colors.green,
            ),

            const SizedBox(height: 16),

            const CommunityCard(
              icon: Icons.account_balance,
              title: 'Govt Scheme Update',
              message:
                  'PM-Kisan installment release expected this month. Check eligibility.',
              color: Colors.blue,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: const AgriBottomNav(currentIndex: 4),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 LEARN CARD                                 */
/* -------------------------------------------------------------------------- */

class LearnCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const LearnCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              COMMUNITY CARD                                */
/* -------------------------------------------------------------------------- */

class CommunityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const CommunityCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
