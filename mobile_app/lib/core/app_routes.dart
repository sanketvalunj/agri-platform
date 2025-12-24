import 'package:flutter/material.dart';

// ================= ONBOARDING =================
import '../features/crop_recommendation/crop_recommendation.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/onboarding/language_select.dart';
import '../features/onboarding/location_setup.dart';
import '../features/onboarding/profile_screen.dart';

// ================= HOME =================
import '../features/home/home_dashboard.dart';

// ================= CHATBOT =================
import '../features/chatbot/chat_screen.dart';

// ================= MARKET =================
import '../features/market/screen/market_price_screen.dart';

// ================= CARBON =================
import '../features/carbon/carbon_overview.dart';
import '../features/carbon/carbon_input.dart';
import '../features/carbon/carbon_dashboard.dart';
import '../features/carbon/carbon_insights.dart';

// ================= ALERTS =================
import '../features/alerts/alerts_screen.dart';

// ================= WEATHER =================
import '../features/crop_recommendation/weather_advisory_screen.dart';

// ================= PROFILE / SETTINGS / HELP =================
import '../features/profile_screen/ProfileSettingsScreen.dart';
import '../features/settings/setting_screen.dart';
import '../features/help/help_screen.dart';

class AppRoutes {
  // ================= ONBOARDING =================

  static const String splash = '/';
  static const String language = '/language';
  static const String location = '/location';
  static const String farmProfile = '/farm-profile';

  // ================= CORE =================
  static const String home = '/home';
  static const String chatbot = '/chatbot';

  // ================= MARKET =================
  static const String market = '/market';

  // ================= CARBON =================
  static const String carbonOverview = '/carbon-overview';
  static const String carbonInput = '/carbon-input';
  static const String carbonDashboard = '/carbon-dashboard';
  static const String carbonInsights = '/carbon-insights';

  // ================= EXTRA =================
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String weather = '/weather';
  static const String cropInput = '/crop-input';

  // ================= ROUTE MAP =================
  static final Map<String, WidgetBuilder> routes = {
    // Onboarding
    splash: (_) => const SplashScreen(),
    language: (_) => const LanguageSelectionScreen(),
    location: (_) => const LocationSetupScreen(),
    farmProfile: (_) => const BasicFarmProfileScreen(),

    // Core
    home: (_) => const HomeDashboardScreen(),
    chatbot: (_) => const ChatbotScreen(),

    market: (_) => const MarketPriceScreen(),

    // Carbon
    carbonOverview: (_) => const CarbonOverviewScreen(),
    carbonInput: (_) => const CarbonInputScreen(),
    carbonDashboard: (_) => const CarbonDashboardScreen(),
    carbonInsights: (_) => const CarbonInsightsScreen(),

    // Alerts / Profile / Help
    alerts: (_) => const AlertsTipsScreen(),
    profile: (_) => const ProfileSettingsScreen(),
    settings: (_) => const SettingsScreen(),
    help: (_) => const HelpHowItWorksScreen(),

    // Weather
    cropInput: (_) => const CropRecommendationScreen(),

    weather: (_) => const WeatherAdvisoryScreen(),
  };
}
