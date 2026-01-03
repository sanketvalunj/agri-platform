import 'dart:ui';
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

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with SingleTickerProviderStateMixin {
  WeatherModel? weather;
  bool isLoading = true;
  bool hasInternet = true;

  late AnimationController _pageController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _pageController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _pageController, curve: Curves.easeOut);
    _slideAnim =
        Tween(begin: const Offset(0, 0.05), end: Offset.zero).animate(_fadeAnim);

    _pageController.forward();
    _loadWeather();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAF5),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 0),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heroHeader(),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _weatherCard(),
                  ),
                  const SizedBox(height: 26),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: !hasInternet ? _offlineBanner() : const SizedBox(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "What would you like to do today?",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        _quickActionGrid(),
                        const SizedBox(height: 32),
                        _smartSuggestions(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HERO HEADER ----------------
  Widget _heroHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _greeting(),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              "Welcome, Avantika",
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ]),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
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
      return _skeletonCard();
    }

    if (weather == null) {
      return const Text("Failed to load weather");
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -6 * value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade400.withOpacity(0.9),
                  Colors.blue.shade700.withOpacity(0.9)
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(weather!.city,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    "${weather!.temperature}°C",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(weather!.description,
                      style: const TextStyle(color: Colors.white70)),
                ]),
                const Icon(Icons.wb_sunny,
                    size: 50, color: Colors.yellowAccent),
              ],
            ),
          ),
        ),
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
          icon: Icons.chat_bubble_outline,
          label: "Ask AI",
          gradient: const [Color(0xFF66BB6A), Color(0xFF2E7D32)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.chatbot),
        ),
        _ActionCard(
          icon: Icons.agriculture,
          label: "Crop Advice",
          gradient: const [Color(0xFF64B5F6), Color(0xFF1976D2)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.cropInput),
        ),
        _ActionCard(
          icon: Icons.trending_up,
          label: "Market Prices",
          gradient: const [Color(0xFFFFB74D), Color(0xFFF57C00)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.market),
        ),
        _ActionCard(
          icon: Icons.cloud_queue,
          label: "Weather",
          gradient: const [Color(0xFF4DD0E1), Color(0xFF00838F)],
          onTap: () => Navigator.pushNamed(context, AppRoutes.weather),
        ),
      ],
    );
  }

  // ---------------- SMART SUGGESTIONS ----------------
  Widget _smartSuggestions() {
    final suggestions = [
      _Suggestion(Icons.eco, Colors.green, "Good day for sowing soybean"),
      _Suggestion(Icons.cloud, Colors.orange, "Rain expected in next 48 hours"),
      _Suggestion(Icons.trending_up, Colors.blue, "High demand for onions today"),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Smart Suggestions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        ...List.generate(suggestions.length, (i) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 300 + i * 150),
            builder: (context, value, child) =>
                Opacity(opacity: value, child: child),
            child: suggestions[i],
          );
        })
      ],
    );
  }

  // ---------------- OFFLINE BANNER ----------------
  Widget _offlineBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.wifi_off, color: Colors.deepOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "No internet connection. Some features may not work.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SKELETON ----------------
  Widget _skeletonCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

// ---------------- COMPONENTS ----------------

class _Suggestion extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _Suggestion(this.icon, this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12),
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

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.gradient,
      required this.onTap});

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.gradient),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 32),
                const SizedBox(height: 10),
                Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
