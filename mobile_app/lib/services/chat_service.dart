import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl =
      "http://127.0.0.1:8000/api/chat/"; // iOS simulator
  // Android emulator: http://10.0.2.2:8000/api/chat

  static Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    String language = "en",
  }) async {
    final body = {
      "user_id": userId,
      "message": message,
      "language": language,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get response from server");
    }
  }
}
