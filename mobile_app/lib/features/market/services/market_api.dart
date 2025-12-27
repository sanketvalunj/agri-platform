import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_price.dart';

class MarketApi {
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<List<MarketPrice>> fetchPrices({
    required String commodity,
    required String state,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/market/prices?commodity=$commodity&state=$state",
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Failed to load prices");
    }

    final List data = json.decode(res.body);
    return data.map((e) => MarketPrice.fromJson(e)).toList();
  }
}
