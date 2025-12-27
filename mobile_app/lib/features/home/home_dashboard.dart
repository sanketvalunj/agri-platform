import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../weather/models/weather_model.dart';
import '../weather/services/weather_service.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 20);
  WeatherModel? weather;
  bool isLoading = true;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final data = await WeatherService.fetchWeather("Pune");
      setState(() {
        weather = data;
        isLoading = false;
        hasInternet = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasInternet = false;
      });
    }
  }

  Widget _offlineBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0B2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.wifi_off, color: Colors.deepOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No internet connection. Some features may not work.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topHeader(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _weatherCard(),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasInternet) _offlineBanner(),
                    const SizedBox(height: 24),
                    const Text(
                      "What would you like to do today?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    _quickActionGrid(),
                    const SizedBox(height: 30),
                    _smartSuggestions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _topHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Evening",
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              SizedBox(height: 4),
              Text(
                "Welcome, Avantika",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              height: 42,
              width: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- WEATHER CARD ----------------
  Widget _weatherCard() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weather == null) {
      return const Text("Failed to load weather");
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weather!.city,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text(
                "${weather!.temperature}°C",
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                weather!.description,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const Icon(Icons.wb_sunny, size: 48, color: Colors.yellow),
        ],
      ),
    );
  }

  // ---------------- QUICK ACTIONS ----------------
  Widget _quickActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _ActionCard(
          icon: Icons.chat,
          label: "Ask AI",
          gradient: const [Color(0xFF66BB6A), Color(0xFF43A047)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.chatbot),
        ),
        _ActionCard(
          icon: Icons.agriculture,
          label: "Crop Advice",
          gradient: const [Color(0xFF64B5F6), Color(0xFF1E88E5)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.cropInput),
        ),
        _ActionCard(
          icon: Icons.bar_chart,
          label: "Market Prices",
          gradient: const [Color(0xFFFFB74D), Color(0xFFF57C00)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.market),
        ),
        _ActionCard(
          icon: Icons.cloud,
          label: "Weather",
          gradient: const [Color(0xFF4DD0E1), Color(0xFF00838F)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.weather),
        ),
      ],
    );
  }

  // ---------------- SUGGESTIONS ----------------
  Widget _smartSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Today's Smart Suggestions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 14),
        _Suggestion(
          color: Colors.green,
          icon: Icons.check_circle,
          text: "Good day for sowing soybean",
        ),
        _Suggestion(
          color: Colors.orange,
          icon: Icons.warning,
          text: "Rain expected in next 48 hours",
        ),
        _Suggestion(
          color: Colors.blue,
          icon: Icons.trending_up,
          text: "High demand for onions today",
        ),
      ],
    );
  }
}

// ---------------- REUSABLE COMPONENTS ----------------

class _Suggestion extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _Suggestion({
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
