import 'package:flutter/material.dart';

class CropRecommendationScreen extends StatelessWidget {
  const CropRecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      appBar: AppBar(
        title: const Text('Crop Recommendation'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.green.shade800,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _topResult(),
            const SizedBox(height: 28),
            _whyThisCrop(),
            const SizedBox(height: 28),
            _profitEstimation(),
            const SizedBox(height: 36),
            _actionCTA(),
          ],
        ),
      ),
    );
  }

  // 🌱 TOP RESULT
  Widget _topResult() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '🌱 Recommended Crop',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            'Soybean',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.verified, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Confidence: 95%',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🧠 EXPLAINABLE ML
  Widget _whyThisCrop() {
    return _whiteCard(
      title: 'Why this crop?',
      children: const [
        _ReasonRow(
          icon: Icons.science,
          label: 'Soil nitrogen',
          value: 'Good',
          color: Colors.green,
        ),
        _ReasonRow(
          icon: Icons.water_drop,
          label: 'Rainfall',
          value: 'Suitable',
          color: Colors.blue,
        ),
        _ReasonRow(
          icon: Icons.thermostat,
          label: 'Temperature',
          value: 'Ideal',
          color: Colors.orange,
        ),
      ],
    );
  }

  // 💰 PROFIT ESTIMATION
  Widget _profitEstimation() {
    return _whiteCard(
      title: 'Profit Estimation',
      children: const [
        _ReasonRow(
          icon: Icons.currency_rupee,
          label: 'Expected Price',
          value: '₹4,800 / quintal',
          color: Colors.green,
        ),
        _ReasonRow(
          icon: Icons.trending_up,
          label: 'Market Demand',
          value: 'High',
          color: Colors.blue,
        ),
      ],
    );
  }

  // 🚜 CTA
  Widget _actionCTA() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text(
        'View detailed cultivation plan',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // 🧱 REUSABLE WHITE CARD
  Widget _whiteCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

// 🔹 REASON ROW
class _ReasonRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ReasonRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
