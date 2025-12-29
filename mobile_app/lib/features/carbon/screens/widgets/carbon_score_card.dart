import 'package:flutter/material.dart';
import '../../models/carbon_model.dart';

class CarbonScoreCard extends StatefulWidget {
  final CarbonData data;
  const CarbonScoreCard({super.key, required this.data});

  @override
  State<CarbonScoreCard> createState() => _CarbonScoreCardState();
}

class _CarbonScoreCardState extends State<CarbonScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carbonAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _carbonAnim = Tween<double>(
      begin: 0,
      end: widget.data.carbonTons,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final conf = widget.data.confidence;
    final isGood = conf >= 80;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Carbon Credits",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            AnimatedBuilder(
              animation: _carbonAnim,
              builder: (_, __) => Text(
                "${_carbonAnim.value.toStringAsFixed(1)} t CO₂",
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 14,
                  color: isGood ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  "$conf% Confidence",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isGood ? Colors.green : Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Verified: ${_formatDate(widget.data.lastUpdated)}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
}
