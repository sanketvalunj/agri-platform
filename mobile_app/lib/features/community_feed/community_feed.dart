import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/agri_bottom_nav.dart';
import '../../../shared/widgets/custom_icon_widget.dart';
import './widgets/compose_fab_widget.dart';
import './widgets/post_card_widget.dart';
import './widgets/trending_topics_widget.dart';

class CommunityFeed extends StatefulWidget {
  const CommunityFeed({Key? key}) : super(key: key);

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int _currentBottomNavIndex = 3;
  bool _isLoading = false;
  String _selectedFilter = 'all';

  // Mock data for community posts
  final List<Map<String, dynamic>> _posts = [
    {
      "id": 1,
      "userId": 101,
      "userName": "Rajesh Kumar",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1d7437585-1763294112440.png",
      "userAvatarLabel":
          "Profile photo of middle-aged Indian farmer with mustache wearing white shirt",
      "location": "Nashik, Maharashtra",
      "expertise": "Grape Farming",
      "verified": true,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "contentType": "text_image",
      "text":
          "Excellent grape harvest this season! Used drip irrigation and organic fertilizers. Yield increased by 30% compared to last year. 🍇",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1612030875630-523f44e143cc",
          "label":
              "Lush green grape vineyard with ripe purple grape clusters hanging from vines"
        }
      ],
      "likes": 234,
      "comments": 45,
      "shares": 12,
      "isLiked": false,
      "hashtags": ["#GrapeFarming", "#OrganicFarming", "#Maharashtra"]
    },
    {
      "id": 2,
      "userId": 102,
      "userName": "Priya Sharma",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_145e9a9c5-1763299194556.png",
      "userAvatarLabel":
          "Profile photo of young Indian woman with long black hair wearing green saree",
      "location": "Ludhiana, Punjab",
      "expertise": "Wheat & Rice",
      "verified": true,
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "contentType": "tip",
      "text":
          "Pro tip for wheat farmers: Apply first irrigation 20-25 days after sowing when soil moisture is 50-60%. This ensures better root development and higher yield. 🌾",
      "images": [],
      "likes": 567,
      "comments": 89,
      "shares": 34,
      "isLiked": true,
      "hashtags": ["#WheatFarming", "#FarmingTips", "#Punjab"]
    },
    {
      "id": 3,
      "userId": 103,
      "userName": "Suresh Patel",
      "userAvatar":
          "https://images.unsplash.com/photo-1731113725786-d1de0ad004cf",
      "userAvatarLabel":
          "Profile photo of elderly Indian farmer with white beard wearing orange turban",
      "location": "Anand, Gujarat",
      "expertise": "Dairy & Cotton",
      "verified": false,
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "contentType": "weather",
      "text":
          "Heavy rainfall expected in Gujarat this week. Fellow cotton farmers, please take precautions to prevent waterlogging. Cover your cotton bales! ☔",
      "images": [],
      "likes": 189,
      "comments": 23,
      "shares": 45,
      "isLiked": false,
      "hashtags": ["#WeatherAlert", "#CottonFarming", "#Gujarat"]
    },
    {
      "id": 4,
      "userId": 104,
      "userName": "Lakshmi Reddy",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1f182aac1-1763299273050.png",
      "userAvatarLabel":
          "Profile photo of middle-aged Indian woman with short hair wearing yellow blouse",
      "location": "Guntur, Andhra Pradesh",
      "expertise": "Chili & Turmeric",
      "verified": true,
      "timestamp": DateTime.now().subtract(Duration(hours: 12)),
      "contentType": "market",
      "text":
          "Chili prices at Guntur market today: Red chili - ₹180/kg, Green chili - ₹45/kg. Good time to sell! Market demand is high. 🌶️",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1433538534219-56b38a74c4c3",
          "label": "Pile of bright red dried chili peppers at market stall"
        }
      ],
      "likes": 423,
      "comments": 67,
      "shares": 28,
      "isLiked": true,
      "hashtags": ["#MarketPrices", "#ChiliFarming", "#AndhraPradesh"]
    },
    {
      "id": 5,
      "userId": 105,
      "userName": "Arun Kumar",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_17876141d-1763295390337.png",
      "userAvatarLabel":
          "Profile photo of young Indian farmer with short black hair wearing blue shirt",
      "location": "Coimbatore, Tamil Nadu",
      "expertise": "Coconut & Banana",
      "verified": false,
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "contentType": "success",
      "text":
          "Started organic banana farming 2 years ago. Today exported my first batch to Dubai! Dreams do come true with hard work. 🍌✈️",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1723726144331-e8e93690209d",
          "label": "Large bunch of ripe yellow bananas hanging from banana tree"
        }
      ],
      "likes": 892,
      "comments": 134,
      "shares": 67,
      "isLiked": false,
      "hashtags": ["#SuccessStory", "#BananaFarming", "#TamilNadu", "#Export"]
    }
  ];

  final List<String> _trendingTopics = [
    "#OrganicFarming",
    "#DroughtManagement",
    "#SoilHealth",
    "#CropRotation",
    "#PestControl",
    "#MarketPrices",
    "#WeatherAlert"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  Future<void> _refreshFeed() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feed refreshed'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentBottomNavIndex = index);

    final routes = [
      '/home-dashboard',
      '/weather-insights',
      '/crop-management',
      '/community-feed',
      '/notifications-center'
    ];

    if (index != 3) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _onFilterChanged(String filter) {
    HapticFeedback.lightImpact();
    setState(() => _selectedFilter = filter);
  }

  void _onPostLike(int postId) {
    HapticFeedback.lightImpact();
    setState(() {
      final post = _posts.firstWhere((p) => p['id'] == postId);
      post['isLiked'] = !post['isLiked'];
      post['likes'] = post['isLiked'] ? post['likes'] + 1 : post['likes'] - 1;
    });
  }

  void _onPostComment(int postId) {
    HapticFeedback.mediumImpact();
    // Navigate to comment screen or show comment bottom sheet
  }

  void _onPostShare(int postId) {
    HapticFeedback.mediumImpact();
    // Implement share functionality
  }

  void _onComposeFabPressed() {
    HapticFeedback.mediumImpact();
    _showComposeBottomSheet();
  }

  void _showComposeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText:
                            'Share your farming experience, tips, or questions...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _buildComposeActionButton(context, 'image', 'Photo'),
                        SizedBox(width: 2.w),
                        _buildComposeActionButton(
                            context, 'camera_alt', 'Camera'),
                        SizedBox(width: 2.w),
                        _buildComposeActionButton(
                            context, 'location_on', 'Location'),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 6.h),
                      ),
                      child: Text('Post'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposeActionButton(
      BuildContext context, String iconName, String label) {
    return OutlinedButton.icon(
      onPressed: () => HapticFeedback.lightImpact(),
      icon: CustomIconWidget(
        iconName: iconName,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Community',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => HapticFeedback.lightImpact(),
            tooltip: 'Search',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => HapticFeedback.lightImpact(),
            tooltip: 'Filter',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Following'),
                  Tab(text: 'Tips'),
                  Tab(text: 'Market'),
                ],
              ),
              SizedBox(height: 1.h),
              TrendingTopicsWidget(
                topics: _trendingTopics,
                onTopicTap: (topic) => HapticFeedback.lightImpact(),
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildFeedList(),
            _buildFeedList(),
            _buildFeedList(),
            _buildFeedList(),
          ],
        ),
      ),
      floatingActionButton: ComposeFabWidget(
        onPressed: _onComposeFabPressed,
      ),
      bottomNavigationBar: AgriBottomNav(currentIndex: _currentBottomNavIndex),
    );
  }

  Widget _buildFeedList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: _posts.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _posts.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = _posts[index];
        return PostCardWidget(
          post: post,
          onLike: () => _onPostLike(post['id']),
          onComment: () => _onPostComment(post['id']),
          onShare: () => _onPostShare(post['id']),
        );
      },
    );
  }
}
