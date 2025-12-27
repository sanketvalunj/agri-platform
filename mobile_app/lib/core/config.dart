import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    } else {
      return "http://10.0.2.2:8000"; // Android Emulator
    }
  }
}
