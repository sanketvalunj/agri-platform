import 'package:flutter/material.dart';

class WeatherAdvisoryScreen extends StatelessWidget {
  const WeatherAdvisoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      appBar: AppBar(
        title: const Text('Weather Advisory'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.blue.shade800,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _mainAlert(),
            const SizedBox(height: 28),
            _actionableAdvice(),
          ],
        ),
      ),
    );
  }

  Widget _mainAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud, color: Colors.white, size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              '🌧 Rain expected in next 48 hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionableAdvice() {
    return Column(
      children: const [
        _AdviceTile(
          icon: Icons.cancel,
          color: Colors.red,
          text: 'Avoid pesticide spraying today',
        ),
        _AdviceTile(
          icon: Icons.agriculture,
          color: Colors.green,
          text: 'Best sowing window: Next 5 days',
        ),
      ],
    );
  }
}

// 🧠 ADVICE TILE
class _AdviceTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _AdviceTile({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
