import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config.dart';
import '../models/weather_model.dart';

class WeatherService {
  static Future<WeatherModel> fetchWeather(String city) async {
    final url = Uri.parse("${AppConfig.baseUrl}/api/weather?city=$city");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather");
    }
  }
}
