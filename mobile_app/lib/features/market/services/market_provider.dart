import 'package:flutter/foundation.dart';
import 'market_api.dart';
import '../models/market_price.dart';

class MarketProvider with ChangeNotifier {
  MarketPriceSummary? _marketSummary;
  bool _isLoading = false;
  String? _error;

  MarketPriceSummary? get marketSummary => _marketSummary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMarketSummary({
    String state = "Maharashtra",
    String commodity = "Tomato",
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final summary = await MarketApi.fetchMarketSummary(
        state: state,
        commodity: commodity,
      );
      _marketSummary = summary;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
