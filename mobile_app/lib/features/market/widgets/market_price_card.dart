import 'package:agri_platform/features/market/models/market_price_model.dart';
import 'package:flutter/material.dart';


class MarketPriceCard extends StatelessWidget {
  final MarketPrice price;

  const MarketPriceCard({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final isUp = price.trend == "up";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUp
              ? [Colors.green.shade400, Colors.green.shade700]
              : [Colors.orange.shade400, Colors.orange.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${price.crop} • ${price.market}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priceColumn("Min", price.minPrice),
              _priceColumn("Avg", price.avgPrice),
              _priceColumn("Max", price.maxPrice),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                "${price.changePercent}% today",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceColumn(String label, int value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          "₹$value",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
