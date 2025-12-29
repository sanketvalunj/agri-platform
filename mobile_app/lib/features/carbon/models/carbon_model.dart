class CarbonData {
  final double carbonTons;
  final int confidence; // 0–100
  final DateTime lastUpdated;

  CarbonData({
    required this.carbonTons,
    required this.confidence,
    required this.lastUpdated,
  });
}
