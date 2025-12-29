import 'package:flutter/material.dart';

class _ConfidenceInfoSheet extends StatelessWidget {
  const _ConfidenceInfoSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How confidence is calculated",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _row("🌳 Trees planted", "Verified via entry & photo"),
          _row("🌾 Soil health", "Based on practice consistency"),
          _row("📡 Satellite match", "NDVI & seasonal validation"),
          _row("📅 Data freshness", "Recent data increases confidence"),

          const SizedBox(height: 12),
          const Text(
            "Higher confidence means your carbon data is more reliable for verification.",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$title – $subtitle",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
