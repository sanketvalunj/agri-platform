import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/add_crop_bottom_sheet.dart';
import './widgets/crop_card_widget.dart';
import './widgets/health_alert_widget.dart';
import './widgets/task_card_widget.dart';
import './widgets/timeline_item_widget.dart';

class CropManagement extends StatefulWidget {
  const CropManagement({Key? key}) : super(key: key);

  @override
  State<CropManagement> createState() => _CropManagementState();
}

class _CropManagementState extends State<CropManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomNavIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for crops
  final List<Map<String, dynamic>> _crops = [
    {
      "id": 1,
      "name": "Wheat Field A",
      "image": "https://images.unsplash.com/photo-1708789324334-b052affecc11",
      "semanticLabel":
          "Golden wheat field with mature grain stalks swaying in sunlight",
      "cropType": "Wheat",
      "area": "2.5 acres",
      "plantedDate": DateTime(2025, 10, 15),
      "expectedHarvest": DateTime(2026, 3, 20),
      "growthStage": "Flowering",
      "growthProgress": 0.65,
      "healthScore": 92,
      "healthStatus": "Excellent",
      "upcomingTasks": [
        {"task": "Irrigation", "dueDate": DateTime(2026, 1, 5)},
        {"task": "Fertilizer Application", "dueDate": DateTime(2026, 1, 10)}
      ],
      "lastActivity": "Pest inspection completed",
      "lastActivityDate": DateTime(2026, 1, 2),
      "weatherDependent": true,
      "alerts": []
    },
    {
      "id": 2,
      "name": "Rice Paddy B",
      "image": "https://images.unsplash.com/photo-1663838593524-8c659a878e71",
      "semanticLabel":
          "Lush green rice paddy field with water-filled terraces under blue sky",
      "cropType": "Rice",
      "area": "3.0 acres",
      "plantedDate": DateTime(2025, 11, 1),
      "expectedHarvest": DateTime(2026, 4, 15),
      "growthStage": "Vegetative",
      "growthProgress": 0.45,
      "healthScore": 78,
      "healthStatus": "Good",
      "upcomingTasks": [
        {"task": "Weeding", "dueDate": DateTime(2026, 1, 6)},
        {"task": "Water Management", "dueDate": DateTime(2026, 1, 8)}
      ],
      "lastActivity": "Fertilizer applied",
      "lastActivityDate": DateTime(2025, 12, 28),
      "weatherDependent": true,
      "alerts": [
        {
          "type": "pest",
          "severity": "medium",
          "message": "Brown plant hopper detected"
        }
      ]
    },
    {
      "id": 3,
      "name": "Cotton Field C",
      "image": "https://images.unsplash.com/photo-1556459201-190f361c7bbe",
      "semanticLabel":
          "White cotton bolls ready for harvest on green cotton plants in field",
      "cropType": "Cotton",
      "area": "4.0 acres",
      "plantedDate": DateTime(2025, 9, 20),
      "expectedHarvest": DateTime(2026, 2, 28),
      "growthStage": "Boll Development",
      "growthProgress": 0.80,
      "healthScore": 85,
      "healthStatus": "Very Good",
      "upcomingTasks": [
        {"task": "Pest Control", "dueDate": DateTime(2026, 1, 7)},
        {"task": "Harvest Preparation", "dueDate": DateTime(2026, 2, 15)}
      ],
      "lastActivity": "Growth monitoring",
      "lastActivityDate": DateTime(2026, 1, 1),
      "weatherDependent": false,
      "alerts": []
    },
    {
      "id": 4,
      "name": "Sugarcane Plot D",
      "image": "https://images.unsplash.com/photo-1650192388648-65800ec59fee",
      "semanticLabel":
          "Tall green sugarcane stalks growing densely in agricultural field",
      "cropType": "Sugarcane",
      "area": "5.5 acres",
      "plantedDate": DateTime(2025, 8, 10),
      "expectedHarvest": DateTime(2026, 8, 30),
      "growthStage": "Grand Growth",
      "growthProgress": 0.55,
      "healthScore": 88,
      "healthStatus": "Very Good",
      "upcomingTasks": [
        {"task": "Irrigation", "dueDate": DateTime(2026, 1, 9)},
        {"task": "Nutrient Check", "dueDate": DateTime(2026, 1, 15)}
      ],
      "lastActivity": "Soil testing",
      "lastActivityDate": DateTime(2025, 12, 30),
      "weatherDependent": true,
      "alerts": []
    }
  ];

  // Mock data for timeline activities
  final List<Map<String, dynamic>> _timelineActivities = [
    {
      "id": 1,
      "cropName": "Wheat Field A",
      "activity": "Pest Inspection",
      "date": DateTime(2026, 1, 2),
      "status": "completed",
      "notes":
          "No major pest issues detected. Minor aphid presence controlled.",
      "photos": [
        {
          "url": "https://images.unsplash.com/photo-1578496125030-44e1953cc6d4",
          "semanticLabel":
              "Close-up photo of wheat stalks showing healthy grain"
        }
      ],
      "performedBy": "Farm Manager"
    },
    {
      "id": 2,
      "cropName": "Rice Paddy B",
      "activity": "Fertilizer Application",
      "date": DateTime(2025, 12, 28),
      "status": "completed",
      "notes": "Applied NPK fertilizer as per soil test recommendations.",
      "photos": [],
      "performedBy": "Field Worker"
    },
    {
      "id": 3,
      "cropName": "Cotton Field C",
      "activity": "Growth Monitoring",
      "date": DateTime(2026, 1, 1),
      "status": "completed",
      "notes":
          "Boll development progressing well. Expected harvest on schedule.",
      "photos": [
        {
          "url": "https://images.unsplash.com/photo-1456937780522-74b439470467",
          "semanticLabel": "Cotton bolls in various stages of development"
        }
      ],
      "performedBy": "Agricultural Officer"
    },
    {
      "id": 4,
      "cropName": "Sugarcane Plot D",
      "activity": "Soil Testing",
      "date": DateTime(2025, 12, 30),
      "status": "completed",
      "notes":
          "Soil pH optimal. Nitrogen levels adequate for current growth stage.",
      "photos": [],
      "performedBy": "Soil Expert"
    },
    {
      "id": 5,
      "cropName": "Wheat Field A",
      "activity": "Irrigation",
      "date": DateTime(2026, 1, 5),
      "status": "pending",
      "notes": "Scheduled irrigation based on weather forecast.",
      "photos": [],
      "performedBy": "Irrigation Team"
    },
    {
      "id": 6,
      "cropName": "Rice Paddy B",
      "activity": "Weeding",
      "date": DateTime(2026, 1, 6),
      "status": "pending",
      "notes": "Manual weeding required in sections A and B.",
      "photos": [],
      "performedBy": "Field Workers"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCrops {
    if (_searchQuery.isEmpty) return _crops;
    return _crops
        .where((crop) =>
            (crop["name"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (crop["cropType"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> get _filteredActivities {
    if (_searchQuery.isEmpty) return _timelineActivities;
    return _timelineActivities
        .where((activity) =>
            (activity["cropName"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (activity["activity"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showAddCropBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCropBottomSheet(),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    HapticFeedback.selectionClick();
    setState(() => _currentBottomNavIndex = index);

    final routes = [
      '/home-dashboard',
      '/weather-insights',
      '/crop-management',
      '/community-feed',
      '/notifications-center'
    ];

    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Crop Management',
        variant: CustomAppBarVariant.contextual,
        locationInfo: 'Nashik, Maharashtra',
        weatherInfo: '28°C Sunny',
        isOnline: true,
        onLocationTap: () {
          HapticFeedback.lightImpact();
        },
        onWeatherTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/weather-insights');
        },
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showFilterOptions();
            },
            tooltip: 'Filter',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'My Crops'),
                Tab(text: 'Timeline'),
                Tab(text: 'Tasks'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(theme),
          _buildFarmOverview(theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCropsTab(theme),
                _buildTimelineTab(theme),
                _buildTasksTab(theme),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCropBottomSheet,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Add Crop',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      color: theme.colorScheme.surface,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search crops or activities...',
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildFarmOverview(ThemeData theme) {
    final totalCrops = _crops.length;
    final activeTasks = _timelineActivities
        .where((activity) => activity["status"] == "pending")
        .length;
    final averageHealth = (_crops.fold<double>(
                0, (sum, crop) => sum + (crop["healthScore"] as int)) /
            totalCrops)
        .round();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewItem(
            theme,
            'Total Crops',
            totalCrops.toString(),
            'agriculture',
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
          _buildOverviewItem(
            theme,
            'Active Tasks',
            activeTasks.toString(),
            'assignment',
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
          ),
          _buildOverviewItem(
            theme,
            'Avg Health',
            '$averageHealth%',
            'favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
      ThemeData theme, String label, String value, String iconName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCropsTab(ThemeData theme) {
    final filteredCrops = _filteredCrops;

    if (filteredCrops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No crops found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: filteredCrops.length,
        itemBuilder: (context, index) {
          return CropCardWidget(
            crop: filteredCrops[index],
            onTap: () {
              HapticFeedback.lightImpact();
              _showCropDetails(filteredCrops[index]);
            },
            onQuickTask: () {
              HapticFeedback.lightImpact();
              _showQuickTaskOptions(filteredCrops[index]);
            },
            onHealthCheck: () {
              HapticFeedback.lightImpact();
              _showHealthCheckOptions(filteredCrops[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildTimelineTab(ThemeData theme) {
    final filteredActivities = _filteredActivities;

    if (filteredActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'timeline',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No activities found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: filteredActivities.length,
        itemBuilder: (context, index) {
          return TimelineItemWidget(
            activity: filteredActivities[index],
            isLast: index == filteredActivities.length - 1,
          );
        },
      ),
    );
  }

  Widget _buildTasksTab(ThemeData theme) {
    final upcomingTasks = <Map<String, dynamic>>[];

    for (var crop in _crops) {
      final tasks = crop["upcomingTasks"] as List;
      for (var task in tasks) {
        upcomingTasks.add({
          "cropName": crop["name"],
          "cropType": crop["cropType"],
          "task": task["task"],
          "dueDate": task["dueDate"],
          "weatherDependent": crop["weatherDependent"],
          "priority": _calculateTaskPriority(task["dueDate"] as DateTime),
        });
      }
    }

    upcomingTasks.sort((a, b) =>
        (a["dueDate"] as DateTime).compareTo(b["dueDate"] as DateTime));

    if (upcomingTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'task_alt',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No upcoming tasks',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: upcomingTasks.length,
        itemBuilder: (context, index) {
          return TaskCardWidget(
            task: upcomingTasks[index],
            onComplete: () {
              HapticFeedback.mediumImpact();
              _completeTask(upcomingTasks[index]);
            },
            onReschedule: () {
              HapticFeedback.lightImpact();
              _rescheduleTask(upcomingTasks[index]);
            },
          );
        },
      ),
    );
  }

  String _calculateTaskPriority(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference <= 1) return 'high';
    if (difference <= 3) return 'medium';
    return 'low';
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomImageWidget(
                          imageUrl: crop["image"] as String,
                          width: double.infinity,
                          height: 30.h,
                          fit: BoxFit.cover,
                          semanticLabel: crop["semanticLabel"] as String,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        crop["name"] as String,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'agriculture',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${crop["cropType"]} • ${crop["area"]}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      _buildDetailSection(
                        theme,
                        'Growth Progress',
                        '${((crop["growthProgress"] as double) * 100).toInt()}%',
                        crop["growthStage"] as String,
                      ),
                      SizedBox(height: 2.h),
                      _buildDetailSection(
                        theme,
                        'Health Status',
                        '${crop["healthScore"]}%',
                        crop["healthStatus"] as String,
                      ),
                      SizedBox(height: 2.h),
                      _buildDetailSection(
                        theme,
                        'Planted Date',
                        _formatDate(crop["plantedDate"] as DateTime),
                        '',
                      ),
                      SizedBox(height: 2.h),
                      _buildDetailSection(
                        theme,
                        'Expected Harvest',
                        _formatDate(crop["expectedHarvest"] as DateTime),
                        '',
                      ),
                      if ((crop["alerts"] as List).isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          'Health Alerts',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...(crop["alerts"] as List).map((alert) {
                          return HealthAlertWidget(
                            alert: alert as Map<String, dynamic>,
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(
      ThemeData theme, String label, String value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showQuickTaskOptions(Map<String, dynamic> crop) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Quick Tasks - ${crop["name"]}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'water_drop',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Schedule Irrigation'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'science',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Apply Fertilizer'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bug_report',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Pest Control'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showHealthCheckOptions(Map<String, dynamic> crop) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Health Check - ${crop["name"]}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Scan Crop Health'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'assessment',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('View Health Report'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'notifications_active',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Set Health Alerts'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Filter Options',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'sort',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Sort by Health'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Sort by Harvest Date'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'filter_alt',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Filter by Crop Type'),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _completeTask(Map<String, dynamic> task) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task["task"]}" marked as complete'),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rescheduleTask(Map<String, dynamic> task) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rescheduling task "${task["task"]}"'),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
