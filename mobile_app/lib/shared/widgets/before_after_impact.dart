import 'package:flutter/material.dart';

class BeforeAfterImpact extends StatelessWidget {
  const BeforeAfterImpact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Impact Comparison',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // ❌ BEFORE
              Expanded(
                child: _ImpactBox(
                  title: 'Before',
                  subtitle: 'Traditional practices',
                  level: 'Low',
                  icon: Icons.trending_down,
                  color: Colors.red.shade400,
                  bgColor: Colors.red.shade50,
                ),
              ),

              const SizedBox(width: 12),

              // ✅ AFTER
              Expanded(
                child: _ImpactBox(
                  title: 'After',
                  subtitle: 'Sustainable practices',
                  level: 'High',
                  icon: Icons.trending_up,
                  color: Colors.green.shade700,
                  bgColor: Colors.green.shade50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String level;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _ImpactBox({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // 👈 large tap/visual area
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Text(
            level,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
