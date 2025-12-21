import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<String> sendMessage(String message) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/");

    print("🔥 CALLING URL: $url");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": "test_user",
        "message": message,
      }),
    );

    print("✅ STATUS CODE: ${response.statusCode}");
    print("✅ RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"].toString();
    } else {
      return "SERVER ERROR ${response.statusCode}";
    }
  }
}
