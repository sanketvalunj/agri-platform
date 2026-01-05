import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_icon_widget.dart';
import '../../shared/widgets/agri_bottom_nav.dart';
import '../weather/weather_advisory_screen.dart';
import '../chatbot/chat_screen.dart';
import '../community_feed/community_feed.dart';
import '../alerts/alerts_screen.dart';
import './widgets/community_highlight_card.dart';
import './widgets/crop_status_card.dart';
import './widgets/quick_action_card.dart';
import './widgets/recent_conversation_item.dart';
import './widgets/weather_summary_card.dart';

class HomeDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const HomeDashboardScreen({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _parallaxController;
  bool _isOnline = true;
  double _scrollOffset = 0.0;
  int _currentIndex = 0;

  // Mock data
  final Map<String, dynamic> _weatherData = {
    'location': 'Pune, Maharashtra',
    'temperature': 28,
    'condition': 'Partly Cloudy',
    'icon': 'wb_cloudy',
    'humidity': 65,
    'windSpeed': 12,
  };

  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'AI Assistant',
      'subtitle': 'Ask farming questions',
      'iconName': 'chat',
      'color': Color(0xFF4CAF50),
      'route': '/chatbot',
    },
    {
      'title': 'Weather',
      'subtitle': 'Detailed forecast',
      'iconName': 'wb_sunny',
      'color': Color(0xFFFFB300),
      'route': '/weather',
    },
    {
      'title': 'My Crops',
      'subtitle': 'Track growth',
      'iconName': 'eco',
      'color': Color(0xFF1B5E20),
      'route': '/cropadvisory',
    },
    {
      'title': 'Community',
      'subtitle': 'Farmer stories',
      'iconName': 'people',
      'color': Color(0xFFFF6F00),
      'route': '/community',
    },
  ];

  final List<Map<String, dynamic>> _recentConversations = [
    {
      'title': 'Wheat Pest Control',
      'preview':
          'How can I protect my wheat crop from aphids during this season?',
      'timestamp': '2 hours ago',
      'suggestions': ['Organic solutions', 'Chemical spray', 'Prevention tips'],
    },
    {
      'title': 'Irrigation Schedule',
      'preview': 'What is the best irrigation schedule for cotton in summer?',
      'timestamp': 'Yesterday',
      'suggestions': ['Drip irrigation', 'Water requirements'],
    },
  ];

  final List<Map<String, dynamic>> _activeCrops = [
    {
      'name': 'Wheat',
      'image': 'https://images.unsplash.com/photo-1595975644151-5f2be3f87148',
      'semanticLabel': 'Golden wheat stalks swaying in field under blue sky',
      'daysSincePlanting': 45,
      'healthStatus': 'Healthy',
      'nextTask': 'Fertilizer application',
    },
    {
      'name': 'Cotton',
      'image': 'https://images.unsplash.com/photo-1726581876086-5f054d00c499',
      'semanticLabel': 'White cotton bolls ready for harvest on green plants',
      'daysSincePlanting': 78,
      'healthStatus': 'Warning',
      'nextTask': 'Pest inspection',
    },
    {
      'name': 'Tomatoes',
      'image': 'https://images.unsplash.com/photo-1598954559798-9f1f86f827f7',
      'semanticLabel': 'Red ripe tomatoes growing on vine in greenhouse',
      'daysSincePlanting': 32,
      'healthStatus': 'Healthy',
      'nextTask': 'Watering',
    },
  ];

  final List<Map<String, dynamic>> _communityHighlights = [
    {
      'author': 'Ramesh Kumar',
      'timestamp': '3 hours ago',
      'title': 'Organic Farming Success Story',
      'content':
          'Switched to organic methods last year and saw 30% increase in yield. Here\'s what worked for me...',
      'image':
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400',
      'semanticLabel':
          'Farmer inspecting healthy green crops in organic farm field',
      'likes': 124,
      'comments': 18,
    },
    {
      'author': 'Priya Sharma',
      'timestamp': '5 hours ago',
      'title': 'Water Conservation Tips',
      'content':
          'Implemented drip irrigation and reduced water usage by 40%. Sharing my experience and setup details...',
      'image':
          'https://img.rocket.new/generatedImages/rocket_gen_img_17db12551-1767182945395.png',
      'semanticLabel':
          'Drip irrigation system watering rows of green plants in field',
      'likes': 89,
      'comments': 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _parallaxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isOnline = true;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _currentIndex == 0
          ? CustomAppBar.home(
              context: context,
              weatherInfo: '${_weatherData['temperature']}°C',
              locationInfo: 'Pune',
              isOnline: _isOnline,
              onWeatherTap: () {
                HapticFeedback.lightImpact();
                setState(() => _currentIndex = 1);
              },
              onLocationTap: () {
                HapticFeedback.lightImpact();
              },
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeBody(theme),
          WeatherAdvisoryScreen(isEmbedded: true),
          ChatbotScreen(),
          const CommunityFeed(),
          const AlertsTipsScreen(),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pushNamed(context, '/chatbot');
              },
              icon: CustomIconWidget(
                iconName: 'mic',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Ask AI',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      bottomNavigationBar: AgriBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildGreetingSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Rajesh Patil',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.3,
            ),
            itemCount: _quickActions.length,
            itemBuilder: (context, index) {
              final action = _quickActions[index];
              return QuickActionCard(
                title: action['title'] as String,
                subtitle: action['subtitle'] as String,
                iconName: action['iconName'] as String,
                backgroundColor: action['color'] as Color,
                onTap: () {
                  Navigator.pushNamed(context, action['route'] as String);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentConversationsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Conversations',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/chatbot');
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _recentConversations.length,
            itemBuilder: (context, index) {
              return RecentConversationItem(
                conversation: _recentConversations[index],
                onTap: () {
                  Navigator.pushNamed(context, '/chatbot');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCropStatusSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Crops',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/crop-management');
                  },
                  child: Text('View All'),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 4.w),
              itemCount: _activeCrops.length,
              itemBuilder: (context, index) {
                return CropStatusCard(
                  crop: _activeCrops[index],
                  onTap: () {
                    Navigator.pushNamed(context, '/crop-management');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityHighlightsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Highlights',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _currentIndex = 3);
                  },
                  child: Text('View All'),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 4.w),
              itemCount: _communityHighlights.length,
              itemBuilder: (context, index) {
                return CommunityHighlightCard(
                  post: _communityHighlights[index],
                  onTap: () {
                    setState(() => _currentIndex = 3);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: theme.colorScheme.primary,
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, _scrollOffset * 0.3),
              child: _buildGreetingSection(theme),
            ),
          ),
          SliverToBoxAdapter(
            child: WeatherSummaryCard(
              weatherData: _weatherData,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _currentIndex = 1);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildQuickActionsSection(theme),
          ),
          SliverToBoxAdapter(
            child: _buildRecentConversationsSection(theme),
          ),
          SliverToBoxAdapter(
            child: _buildCropStatusSection(theme),
          ),
          SliverToBoxAdapter(
            child: _buildCommunityHighlightsSection(theme),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }
}
