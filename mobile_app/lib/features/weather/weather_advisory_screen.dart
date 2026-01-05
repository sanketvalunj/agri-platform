import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_icon_widget.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import './widgets/current_weather_header_widget.dart';
import './widgets/farming_advisory_widget.dart';
import './widgets/hourly_forecast_widget.dart';
import './widgets/seven_day_forecast_widget.dart';
import './widgets/weather_alerts_widget.dart';
import './widgets/weather_charts_widget.dart';

class WeatherAdvisoryScreen extends StatefulWidget {
  final bool isEmbedded;
  const WeatherAdvisoryScreen({Key? key, this.isEmbedded = false})
      : super(key: key);

  @override
  State<WeatherAdvisoryScreen> createState() => _WeatherAdvisoryScreenState();
}

class _WeatherAdvisoryScreenState extends State<WeatherAdvisoryScreen> {
  int _currentBottomNavIndex = 1; // Weather tab
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock weather data
  final Map<String, dynamic> _currentWeather = {
    "temperature": 28,
    "condition": "Partly Cloudy",
    "icon": "wb_cloudy",
    "location": "Nashik, Maharashtra",
    "gpsAccuracy": "High",
    "humidity": 65,
    "windSpeed": 12,
    "uvIndex": 7,
    "soilMoisture": 45,
    "feelsLike": 30,
  };

  final List<Map<String, dynamic>> _hourlyForecast = [
    {
      "time": "Now",
      "temperature": 28,
      "icon": "wb_cloudy",
      "precipitation": 10,
      "windSpeed": 12
    },
    {
      "time": "11 AM",
      "temperature": 30,
      "icon": "wb_sunny",
      "precipitation": 5,
      "windSpeed": 15
    },
    {
      "time": "12 PM",
      "temperature": 32,
      "icon": "wb_sunny",
      "precipitation": 0,
      "windSpeed": 18
    },
    {
      "time": "1 PM",
      "temperature": 33,
      "icon": "wb_sunny",
      "precipitation": 0,
      "windSpeed": 20
    },
    {
      "time": "2 PM",
      "temperature": 34,
      "icon": "wb_sunny",
      "precipitation": 0,
      "windSpeed": 22
    },
    {
      "time": "3 PM",
      "temperature": 33,
      "icon": "wb_cloudy",
      "precipitation": 15,
      "windSpeed": 20
    },
    {
      "time": "4 PM",
      "temperature": 31,
      "icon": "cloud",
      "precipitation": 30,
      "windSpeed": 18
    },
    {
      "time": "5 PM",
      "temperature": 29,
      "icon": "cloud",
      "precipitation": 40,
      "windSpeed": 15
    },
  ];

  final List<Map<String, dynamic>> _sevenDayForecast = [
    {
      "day": "Today",
      "date": "Jan 3",
      "high": 34,
      "low": 22,
      "condition": "Partly Cloudy",
      "icon": "wb_cloudy",
      "precipitation": 20,
      "advice": "Good for irrigation in morning"
    },
    {
      "day": "Fri",
      "date": "Jan 4",
      "high": 32,
      "low": 21,
      "condition": "Sunny",
      "icon": "wb_sunny",
      "precipitation": 5,
      "advice": "Ideal for pesticide application"
    },
    {
      "day": "Sat",
      "date": "Jan 5",
      "high": 30,
      "low": 20,
      "condition": "Cloudy",
      "icon": "cloud",
      "precipitation": 40,
      "advice": "Delay fertilizer application"
    },
    {
      "day": "Sun",
      "date": "Jan 6",
      "high": 28,
      "low": 19,
      "condition": "Rainy",
      "icon": "grain",
      "precipitation": 80,
      "advice": "Avoid field operations"
    },
    {
      "day": "Mon",
      "date": "Jan 7",
      "high": 29,
      "low": 20,
      "condition": "Partly Cloudy",
      "icon": "wb_cloudy",
      "precipitation": 30,
      "advice": "Resume normal activities"
    },
    {
      "day": "Tue",
      "date": "Jan 8",
      "high": 31,
      "low": 21,
      "condition": "Sunny",
      "icon": "wb_sunny",
      "precipitation": 10,
      "advice": "Good for harvesting"
    },
    {
      "day": "Wed",
      "date": "Jan 9",
      "high": 33,
      "low": 22,
      "condition": "Sunny",
      "icon": "wb_sunny",
      "precipitation": 5,
      "advice": "Optimal planting conditions"
    },
  ];

  final List<Map<String, dynamic>> _weatherAlerts = [
    {
      "type": "warning",
      "title": "High UV Index Alert",
      "message":
          "UV index will reach 9 between 11 AM - 3 PM. Protect crops sensitive to sun damage.",
      "icon": "wb_sunny",
      "action": "View Details",
      "severity": "medium"
    },
    {
      "type": "info",
      "title": "Optimal Planting Window",
      "message":
          "Next 3 days show ideal conditions for wheat sowing with moderate temperatures and low rainfall.",
      "icon": "eco",
      "action": "Schedule Activity",
      "severity": "low"
    },
  ];

  final Map<String, dynamic> _farmingAdvisory = {
    "title": "Today's Farming Advisory",
    "recommendations": [
      {
        "category": "Irrigation",
        "advice":
            "Morning irrigation recommended. Soil moisture at 45% - water requirement moderate.",
        "icon": "water_drop",
        "priority": "high"
      },
      {
        "category": "Pest Control",
        "advice":
            "Weather conditions favorable for pest activity. Monitor crops closely for next 48 hours.",
        "icon": "bug_report",
        "priority": "medium"
      },
      {
        "category": "Harvesting",
        "advice":
            "Good harvesting conditions for next 2 days. Plan accordingly for wheat and vegetables.",
        "icon": "agriculture",
        "priority": "high"
      },
      {
        "category": "Fertilizer",
        "advice":
            "Delay fertilizer application until after expected rainfall on Saturday.",
        "icon": "science",
        "priority": "low"
      },
    ],
    "aiInsight":
        "Based on your cotton crop and current weather patterns, focus on irrigation management. The upcoming temperature rise may increase water stress. Consider early morning watering to minimize evaporation losses."
  };

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    HapticFeedback.lightImpact();
  }

  void _handleLocationChange() {
    HapticFeedback.lightImpact();
    // Navigate to location selection screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location selection feature'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    HapticFeedback.selectionClick();
    setState(() => _currentBottomNavIndex = index);

    final routes = [
      '/home-dashboard',
      '/weather-insights',
      '/crop-management',
      '/community-feed',
      '/notifications-center',
    ];

    if (index != 1) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final body = RefreshIndicator(
      onRefresh: _handleRefresh,
      color: theme.colorScheme.primary,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          // Last updated timestamp
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'update',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Updated ${_formatLastUpdated()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Current Weather Header
          SliverToBoxAdapter(
            child: CurrentWeatherHeaderWidget(
              weatherData: _currentWeather,
            ),
          ),
          // Weather Alerts
          if (_weatherAlerts.isNotEmpty)
            SliverToBoxAdapter(
              child: WeatherAlertsWidget(
                alerts: _weatherAlerts,
              ),
            ),
          // Hourly Forecast
          SliverToBoxAdapter(
            child: HourlyForecastWidget(
              hourlyData: _hourlyForecast,
            ),
          ),
          // Weather Charts
          SliverToBoxAdapter(
            child: WeatherChartsWidget(
              hourlyData: _hourlyForecast,
            ),
          ),
          // Seven Day Forecast
          SliverToBoxAdapter(
            child: SevenDayForecastWidget(
              forecastData: _sevenDayForecast,
            ),
          ),
          // Farming Advisory
          SliverToBoxAdapter(
            child: FarmingAdvisoryWidget(
              advisoryData: _farmingAdvisory,
            ),
          ),
          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );

    if (widget.isEmbedded) {
      return body;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Weather Insights',
        variant: CustomAppBarVariant.contextual,
        locationInfo: _currentWeather["location"] as String,
        weatherInfo: "${_currentWeather["temperature"]}°C",
        isOnline: true,
        onLocationTap: _handleLocationChange,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calendar integration feature'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Schedule Activity',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/notifications-center');
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: body,
    );
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
