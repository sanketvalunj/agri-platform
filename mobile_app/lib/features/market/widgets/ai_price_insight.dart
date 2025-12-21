import 'package:flutter/material.dart';

class AiPriceInsight extends StatelessWidget {
  const AiPriceInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "AI Market Insight 💡",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Text("• Prices rising due to low supply"),
          Text("• Selling in next 2–3 days is profitable"),
          Text("• Avoid long storage to reduce losses"),
        ],
      ),
    );
  }
}
