import 'package:flutter/material.dart';
import '../models/market_price.dart';
import '../services/market_api.dart';
import '../widgets/market_price_card.dart';

class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({super.key});

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  List<MarketPrice> prices = [];
  bool loading = true;
  String selectedState = "Uttar Pradesh";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await MarketApi.fetchPrices(
        commodity: "Tomato",
        state: selectedState,
      );
      setState(() => prices = data);
    } catch (e) {
      debugPrint("API error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Market Prices")),
      body: Column(
        children: [
          _stateDropdown(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : prices.isEmpty
                    ? const Center(child: Text("No data available"))
                    : ListView.builder(
                        itemCount: prices.length,
                        itemBuilder: (_, i) =>
                            MarketPriceCard(price: prices[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _stateDropdown() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<String>(
        value: selectedState,
        items: const [
          DropdownMenuItem(
              value: "Uttar Pradesh", child: Text("Uttar Pradesh")),
          DropdownMenuItem(value: "Maharashtra", child: Text("Maharashtra")),
          DropdownMenuItem(value: "Delhi", child: Text("Delhi")),
        ],
        onChanged: (val) {
          setState(() => selectedState = val!);
          _loadData();
        },
        decoration: const InputDecoration(
          labelText: "Select State",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
