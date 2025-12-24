import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../shared/widgets/agri_bottom_nav.dart';

/* -------------------------------------------------------------------------- */
/*                            MARKET PRICE SCREEN                              */
/* -------------------------------------------------------------------------- */

class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({Key? key}) : super(key: key);

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  String selectedCrop = 'Tomato';
  String selectedMarket = 'Nashik Mandi';
  String selectedDate = 'Yesterday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),

      appBar: AppBar(
        title: const Text('Market Price Advisory'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.alerts);
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _filterChips(),
          const SizedBox(height: 20),

          _priceCard(
            crop: 'Maize (मक्का)',
            price: '₹1950.00',
            change: '+0.8%',
            positive: true,
            action: 'Sell',
          ),
          _priceCard(
            crop: 'Potato (आलू)',
            price: '₹1500.50',
            change: '-0.3%',
            positive: false,
            action: 'Hold',
          ),
          _priceCard(
            crop: 'Tomato (टमाटर)',
            price: '₹850.00',
            change: '+2.1%',
            positive: true,
            action: 'Sell',
          ),

          const SizedBox(height: 24),
          _trendChart(),
        ],
      ),

      bottomNavigationBar: const AgriBottomNav(currentIndex: 2),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                  FILTERS                                   */
  /* -------------------------------------------------------------------------- */

  Widget _filterChips() {
    return Row(
      children: [
        _filterChip(selectedCrop),
        const SizedBox(width: 10),
        _filterChip(selectedMarket),
        const SizedBox(width: 10),
        _filterChip(selectedDate),
      ],
    );
  }

  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                               PRICE CARD                                   */
  /* -------------------------------------------------------------------------- */

  Widget _priceCard({
    required String crop,
    required String price,
    required String change,
    required bool positive,
    required String action,
  }) {
    final color = positive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(crop,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(price,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(change,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: action == 'Sell'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(action,
                    style: TextStyle(
                        color: action == 'Sell'
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              const Text('Agmarknet',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                               TREND CHART                                  */
  /* -------------------------------------------------------------------------- */

  Widget _trendChart() {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wheat Price Trend',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: Center(
              child: Text('📈 Chart Placeholder (Last 7 Days)',
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
