import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// HelpHowItWorksScreen
/// --------------------
/// Purpose:
/// - Explain Agri Bot in very simple language
/// - Help farmers understand features without training
///
/// UX Principles:
/// - Simple sentences
/// - Icons + text
/// - Large tap areas
///
/// NOTE:
/// - UI only
/// - No backend logic

class HelpHowItWorksScreen extends StatelessWidget {
  const HelpHowItWorksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Help & How It Works',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            HelpCard(
              icon: Icons.chat,
              title: 'Ask Agri Bot',
              description:
                  'Ask farming questions like crops, fertilizer, water, or diseases. '
                  'Agri Bot gives simple answers to help you.',
            ),
            SizedBox(height: 16),
            HelpCard(
              icon: Icons.eco,
              title: 'Carbon Credits',
              description:
                  'When you do eco-friendly farming, you earn carbon credits. '
                  'These credits can help you earn money in the future.',
            ),
            SizedBox(height: 16),
            HelpCard(
              icon: Icons.bar_chart,
              title: 'Carbon Dashboard',
              description: 'This shows how your farming helps the environment. '
                  'You can see your carbon score and impact.',
            ),
            SizedBox(height: 16),
            HelpCard(
              icon: Icons.notifications,
              title: 'Alerts & Tips',
              description: 'Get reminders, farming tips, and seasonal advice '
                  'to improve crop health and yield.',
            ),
            SizedBox(height: 24),
            InfoBox(
              message:
                  'Agri Bot works best with internet, but some features can still be used offline.',
            ),
          ],
        ),
      ),

      // 🟢 Bottom Navigation
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
    );
  }
}

/// 🔹 Reusable Help Card
class HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HelpCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade700.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.green.shade700,
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
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ℹ️ Info Box
class InfoBox extends StatelessWidget {
  final String message;

  const InfoBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Agri Bot works best with internet, but some features can still be used offline.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
