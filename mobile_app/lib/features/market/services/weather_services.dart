import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = "http://10.0.0.1:8000"; // emulator
  // For real phone use: http://<your-laptop-ip>:8000

  static Future<Map<String, dynamic>> getWeather(String district) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?district=$district'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather");
    }
  }
}
