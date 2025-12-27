class MarketPrice {
  final String commodity;
  final String mandi;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final String date;

  MarketPrice({
    required this.commodity,
    required this.mandi,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.date,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      commodity: json['commodity'],
      mandi: json['mandi'],
      minPrice: (json['min_price'] as num).toDouble(),
      maxPrice: (json['max_price'] as num).toDouble(),
      modalPrice: (json['modal_price'] as num).toDouble(),
      date: json['arrival_date'],
    );
  }
}
