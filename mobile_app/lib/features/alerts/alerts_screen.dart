import 'package:flutter/material.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

class AlertsTipsScreen extends StatelessWidget {
  const AlertsTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6), // soft modern bg

      // 🔔 AppBar (clean like second image)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Alerts & Proactive Actions',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_active, color: Colors.green),
          )
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          key: const ValueKey('alerts'),
          padding: const EdgeInsets.all(20),
          children: const [
            AlertCard(
              type: AlertType.weather,
              title: 'Heavy Rain Expected Tomorrow',
              message: 'Cover stored crops and avoid fertilizer spraying.',
              action: 'Prepare drainage & protect harvest',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.pest,
              title: 'Pest Risk Detected',
              message: 'High humidity may cause pest infestation.',
              action: 'Inspect leaves and use neem-based spray',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.market,
              title: 'Onion Price Spike',
              message: 'Prices increased sharply in Pune mandi.',
              action: 'Good time to sell within next 2 days',
            ),
            SizedBox(height: 16),
            AlertCard(
              type: AlertType.sowing,
              title: 'Ideal Sowing Window',
              message: 'Soil moisture and temperature are favorable.',
              action: 'Start soybean sowing this week',
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                ALERT CARD                                  */
/* -------------------------------------------------------------------------- */

enum AlertType { weather, pest, market, sowing }

class AlertCard extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final String action;

  const AlertCard({
    Key? key,
    required this.type,
    required this.title,
    required this.message,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = _alertConfig(type);

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
      child: Row(
        children: [
          // 🎨 LEFT COLOR STRIP (FINTECH STYLE)
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: config.color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY ROW
                  Row(
                    children: [
                      Icon(config.icon, color: config.color, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        config.label,
                        style: TextStyle(
                          color: config.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // MESSAGE
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 👉 ACTION
                  Row(
                    children: [
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          action,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: config.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _AlertUIConfig _alertConfig(AlertType type) {
    switch (type) {
      case AlertType.weather:
        return _AlertUIConfig(
          color: Colors.blue,
          icon: Icons.cloud,
          label: 'Weather Alert',
        );
      case AlertType.pest:
        return _AlertUIConfig(
          color: Colors.redAccent,
          icon: Icons.bug_report,
          label: 'Pest Risk',
        );
      case AlertType.market:
        return _AlertUIConfig(
          color: Colors.green,
          icon: Icons.trending_up,
          label: 'Market Alert',
        );
      case AlertType.sowing:
        return _AlertUIConfig(
          color: Colors.orange,
          icon: Icons.agriculture,
          label: 'Sowing Advice',
        );
    }
  }
}

class _AlertUIConfig {
  final Color color;
  final IconData icon;
  final String label;

  _AlertUIConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
}
