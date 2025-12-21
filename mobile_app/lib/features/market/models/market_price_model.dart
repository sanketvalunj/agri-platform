class MarketPrice {
  final String crop;
  final String market;

  final int minPrice;
  final int avgPrice;
  final int maxPrice;

  final double changePercent;
  final String trend;
  final String lastUpdated;

  MarketPrice({
    required this.crop,
    required this.market,
    required this.minPrice,
    required this.avgPrice,
    required this.maxPrice,
    required this.changePercent,
    required this.trend,
    required this.lastUpdated,
  });
}
