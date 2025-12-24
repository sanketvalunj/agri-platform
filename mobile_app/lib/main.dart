import 'package:flutter/material.dart';
import './core/app_routes.dart';

void main() {
  runApp(const AgriBotApp());
}

/// AgriBotApp
/// ----------
/// Root widget of the application
///
/// Responsibilities:
/// - Initialize MaterialApp
/// - Attach routes
/// - Set global theme
/// - Decide initial screen
///
/// NOTE:
/// - No business logic here
/// - Clean & production-ready

class AgriBotApp extends StatelessWidget {
  const AgriBotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Bot',
      debugShowCheckedModeBanner: false,

      // 🎨 Global theme (farmer-friendly)
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56), // 👈 big buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.green.shade50,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // 🧭 Routing
      routes: AppRoutes.routes,

      // 🚀 App entry point
      initialRoute: AppRoutes.splash,
    );
  }
}
