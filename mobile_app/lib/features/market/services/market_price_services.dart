import '../models/market_price_model.dart';

class MarketPriceService {
  static Future<MarketPrice> fetchPrice({
    required String crop,
    required String market,
    required String date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return MarketPrice(
      crop: crop,
      market: market,
      minPrice: 4500,
      avgPrice: 4800,
      maxPrice: 5100,
      changePercent: 2.3,
      trend: 'Upward',
      lastUpdated: date,
    );
  }
}
