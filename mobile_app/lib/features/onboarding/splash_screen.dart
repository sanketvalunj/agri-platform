import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_routes.dart';

/// SplashScreen
/// ------------
/// Purpose:
/// - First impression of Agri Bot
/// - Build trust with farmers
/// - Smooth transition into onboarding
///
/// UX Principles:
/// - Minimal
/// - Clear branding
/// - No decisions required from user
///
/// NOTE:
/// - UI only
/// - No backend checks
/// - Timer-based navigation

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Splash delay (2 seconds)
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.language, // Start onboarding
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🌱 App Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 72,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // 🧑‍🌾 App Name
              const Text(
                'Agri Bot',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // 🌾 Tagline
              const Text(
                'Smart Farming Assistant',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // ⏳ Loading Indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
