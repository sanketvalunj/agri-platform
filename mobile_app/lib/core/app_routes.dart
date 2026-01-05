import 'package:flutter/material.dart';
import './app_export.dart';

// ================= ONBOARDING =================
import '../features/crop_advisory_screen/crop_advisory_screen.dart';
import '../features/onboarding/language_select.dart';
import '../features/onboarding/location_setup.dart';
import '../features/onboarding/profile_screen.dart';

// ================= HOME =================
import '../features/home/home_screen_dashboard.dart';
import '../features/crop_management/crop_management.dart';
import '../features/weather/weather_advisory_screen.dart';
import '../features/voice_input_screen/voice_input_screen.dart';

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
import '../features/community_feed/community_feed.dart';

// ================= WEATHER =================

// ================= PROFILE / SETTINGS / HELP =================
import '../features/profile_screen/ProfileSettingsScreen.dart';
import '../features/profile/edit_profile_screen.dart';
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
  static const String voiceInput = '/voice-input';

  // ================= MARKET =================
  static const String market = '/market';

  // ================= CARBON =================
  static const String carbonOverview = '/carbon-overview';
  static const String carbonInput = '/carbon-input';
  static const String carbonDashboard = '/carbon-dashboard';
  static const String carbonInsights = '/carbon-insights';

  // ================= EXTRA =================
  static const String alerts = '/alerts';
  static const String community = '/community';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String cropadvisory = '/crop-advisory';
  static const String cropManagement = '/crop-management';
  static const String weather = '/weather';

  // ================= ROUTE MAP =================
  static final Map<String, WidgetBuilder> routes = {
    // Onboarding
    // splash: (_) => const SplashScreen(), // Removed - handled by AuthWrapper
    language: (_) => const LanguageSelectionScreen(),
    location: (_) => const LocationSetupScreen(),
    farmProfile: (_) => const BasicFarmProfileScreen(),

    // Core - Dashboard with different initial indices
    home: (_) => const HomeDashboardScreen(initialIndex: 0),
    chatbot: (_) => const ChatbotScreen(),

    market: (_) => const MarketPriceScreen(),

    // Carbon
    carbonOverview: (_) => const CarbonOverviewScreen(),
    carbonInput: (_) => const CarbonInputScreen(),
    carbonDashboard: (_) => const CarbonDashboardScreen(),
    carbonInsights: (_) => const CarbonInsightsScreen(),

    // Alerts / Profile / Help
    alerts: (_) => const HomeDashboardScreen(initialIndex: 4),
    profile: (_) => const ProfileSettingsScreen(),
    editProfile: (_) => const EditProfileScreen(),
    settings: (_) => const SettingsScreen(),
    help: (_) => const HelpHowItWorksScreen(),

    // Weather
    cropadvisory: (_) => const HomeDashboardScreen(initialIndex: 2),
    cropManagement: (_) => const CropManagement(),
    voiceInput: (_) => const VoiceInputScreen(),
    weather: (_) => const HomeDashboardScreen(initialIndex: 1),
    community: (_) => const HomeDashboardScreen(initialIndex: 3),
  };
}
