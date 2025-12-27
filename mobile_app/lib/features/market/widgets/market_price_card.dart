import 'package:flutter/material.dart';
import '../models/market_price.dart';

class MarketPriceCard extends StatelessWidget {
  final MarketPrice price;
  const MarketPriceCard({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final bool up = price.modalPrice >= price.minPrice;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${price.commodity} • ${price.mandi}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text("₹${price.modalPrice}",
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text("Min ₹${price.minPrice}"),
              const SizedBox(width: 16),
              Text("Max ₹${price.maxPrice}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                up ? Icons.trending_up : Icons.trending_down,
                color: up ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                up ? "Price Rising" : "Price Falling",
                style: TextStyle(
                  color: up ? Colors.green : Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
