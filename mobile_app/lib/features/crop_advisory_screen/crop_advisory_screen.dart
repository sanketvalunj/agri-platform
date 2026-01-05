import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_icon_widget.dart';
import './widget/care_calendar_widget.dart';
import './widget/crop_selection_grid_widget.dart ';
import './widget/fertilizer_reminder_widget.dart';
import './widget/growth_stage_tracker_widget.dart';
import './widget/quick_action_buttons_widget.dart';

/// Crop Advisory Screen - Comprehensive crop management guidance
/// Provides visual crop selection, growth stage tracking, and care recommendations
class CropAdvisoryScreen extends StatefulWidget {
  const CropAdvisoryScreen({super.key});

  @override
  State<CropAdvisoryScreen> createState() => _CropAdvisoryScreenState();
}

class _CropAdvisoryScreenState extends State<CropAdvisoryScreen> {
  int _currentBottomNavIndex = 0;
  String? _selectedCropId;
  String _selectedLanguage = 'en';
  bool _isLoading = false;

  // Mock data for crops with seasonal relevance
  final List<Map<String, dynamic>> _crops = [
    {
      "id": "wheat",
      "name": "Wheat",
      "localName": "गेहूं",
      "image": "https://images.unsplash.com/photo-1595975644151-5f2be3f87148",
      "semanticLabel": "Golden wheat stalks swaying in field under blue sky",
      "season": "Rabi",
      "isCurrentSeason": true,
      "recommendation": "Ideal sowing time - October to November",
    },
    {
      "id": "rice",
      "name": "Rice",
      "localName": "धान",
      "image": "https://images.unsplash.com/photo-1707235164873-e11203d35a74",
      "semanticLabel": "Green rice paddy field with water reflection",
      "season": "Kharif",
      "isCurrentSeason": false,
      "recommendation": "Prepare for next season - June to July",
    },
    {
      "id": "cotton",
      "name": "Cotton",
      "localName": "कपास",
      "image": "https://images.unsplash.com/photo-1574772579417-8aed55bff7a9",
      "semanticLabel": "White cotton bolls ready for harvest on green plant",
      "season": "Kharif",
      "isCurrentSeason": false,
      "recommendation": "Sowing season - May to June",
    },
    {
      "id": "sugarcane",
      "name": "Sugarcane",
      "localName": "गन्ना",
      "image": "https://images.unsplash.com/photo-1632289432111-0e2519584350",
      "semanticLabel": "Tall green sugarcane stalks in agricultural field",
      "season": "Year-round",
      "isCurrentSeason": true,
      "recommendation": "Planting possible throughout year",
    },
    {
      "id": "maize",
      "name": "Maize",
      "localName": "मक्का",
      "image": "https://images.unsplash.com/photo-1601151992832-cd6e18a8e6b8",
      "semanticLabel": "Yellow corn cobs with green husks on wooden surface",
      "season": "Kharif",
      "isCurrentSeason": false,
      "recommendation": "Best sowing - June to July",
    },
    {
      "id": "soybean",
      "name": "Soybean",
      "localName": "सोयाबीन",
      "image": "https://images.unsplash.com/photo-1570376186447-d63f2ac0e80e",
      "semanticLabel": "Brown soybean pods on green plant with leaves",
      "season": "Kharif",
      "isCurrentSeason": false,
      "recommendation": "Sowing period - June to July",
    },
  ];

  // Mock data for growth stages
  final Map<String, List<Map<String, dynamic>>> _growthStages = {
    "wheat": [
      {
        "stage": "Sowing",
        "duration": "0-7 days",
        "icon": "grass",
        "isCompleted": true,
        "isCurrent": false,
        "guidance": [
          "Use certified seeds (100-125 kg/hectare)",
          "Seed treatment with fungicide",
          "Maintain 20-23 cm row spacing",
          "Sowing depth: 5-6 cm",
        ],
      },
      {
        "stage": "Germination",
        "duration": "7-21 days",
        "icon": "eco",
        "isCompleted": true,
        "isCurrent": false,
        "guidance": [
          "First irrigation after 20-25 days",
          "Monitor for seed germination rate",
          "Remove weeds manually if needed",
          "Check soil moisture daily",
        ],
      },
      {
        "stage": "Tillering",
        "duration": "21-60 days",
        "icon": "nature",
        "isCompleted": false,
        "isCurrent": true,
        "guidance": [
          "Apply first nitrogen dose (50 kg/hectare)",
          "Second irrigation at crown root stage",
          "Monitor for aphids and termites",
          "Weed control essential at this stage",
        ],
      },
      {
        "stage": "Jointing",
        "duration": "60-90 days",
        "icon": "park",
        "isCompleted": false,
        "isCurrent": false,
        "guidance": [
          "Apply second nitrogen dose (50 kg/hectare)",
          "Third irrigation at jointing stage",
          "Watch for rust and powdery mildew",
          "Ensure adequate soil moisture",
        ],
      },
      {
        "stage": "Flowering",
        "duration": "90-110 days",
        "icon": "local_florist",
        "isCompleted": false,
        "isCurrent": false,
        "guidance": [
          "Fourth irrigation during flowering",
          "Monitor for aphids and thrips",
          "Avoid water stress during this stage",
          "Check for fungal diseases",
        ],
      },
      {
        "stage": "Grain Filling",
        "duration": "110-130 days",
        "icon": "grain",
        "isCompleted": false,
        "isCurrent": false,
        "guidance": [
          "Fifth irrigation at milk stage",
          "Monitor grain development",
          "Protect from birds and rodents",
          "Check for late season diseases",
        ],
      },
      {
        "stage": "Harvest",
        "duration": "130-150 days",
        "icon": "agriculture",
        "isCompleted": false,
        "isCurrent": false,
        "guidance": [
          "Harvest when moisture is 20-25%",
          "Use combine harvester for efficiency",
          "Dry grains to 12% moisture",
          "Store in clean, dry place",
        ],
      },
    ],
  };

  // Mock data for fertilizer reminders
  final List<Map<String, dynamic>> _fertilizerReminders = [
    {
      "id": "1",
      "name": "Nitrogen (Urea)",
      "quantity": "50 kg/hectare",
      "timing": "At tillering stage (21-30 days)",
      "status": "upcoming",
      "daysRemaining": 5,
      "instructions":
          "Apply when soil is moist. Mix with soil after application.",
    },
    {
      "id": "2",
      "name": "Phosphorus (DAP)",
      "quantity": "60 kg/hectare",
      "timing": "At sowing time",
      "status": "completed",
      "daysRemaining": 0,
      "instructions": "Apply as basal dose during land preparation.",
    },
    {
      "id": "3",
      "name": "Potassium (MOP)",
      "quantity": "40 kg/hectare",
      "timing": "At sowing time",
      "status": "completed",
      "daysRemaining": 0,
      "instructions": "Mix with soil before sowing for better results.",
    },
    {
      "id": "4",
      "name": "Nitrogen (Urea)",
      "quantity": "50 kg/hectare",
      "timing": "At jointing stage (60-70 days)",
      "status": "pending",
      "daysRemaining": 35,
      "instructions": "Apply during irrigation for better absorption.",
    },
  ];

  // Mock data for care calendar
  final List<Map<String, dynamic>> _careCalendar = [
    {
      "month": "January",
      "activities": [
        {
          "icon": "water_drop",
          "title": "Irrigation",
          "description": "Third irrigation at jointing stage",
        },
        {
          "icon": "bug_report",
          "title": "Pest Control",
          "description": "Monitor for aphids and apply neem oil if needed",
        },
      ],
    },
    {
      "month": "February",
      "activities": [
        {
          "icon": "water_drop",
          "title": "Irrigation",
          "description": "Fourth irrigation during flowering",
        },
        {
          "icon": "healing",
          "title": "Disease Management",
          "description": "Check for rust and apply fungicide if required",
        },
      ],
    },
    {
      "month": "March",
      "activities": [
        {
          "icon": "water_drop",
          "title": "Irrigation",
          "description": "Fifth irrigation at milk stage",
        },
        {
          "icon": "agriculture",
          "title": "Harvest Preparation",
          "description": "Arrange harvesting equipment and labor",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  void _handleBottomNavTap(int index) {
    HapticFeedback.lightImpact();
    setState(() => _currentBottomNavIndex = index);
  }

  void _handleLanguageChange(String languageCode) {
    HapticFeedback.lightImpact();
    setState(() => _selectedLanguage = languageCode);
  }

  void _handleCropSelection(String cropId) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedCropId = cropId);
  }

  void _handleBackToCropSelection() {
    HapticFeedback.lightImpact();
    setState(() => _selectedCropId = null);
  }

  void _handleQuickAction(String action) {
    HapticFeedback.lightImpact();

    switch (action) {
      case 'pest':
        Navigator.pushNamed(context, '/chatbot-interface-screen');
        break;
      case 'weather':
        Navigator.pushNamed(context, '/weather-advisory-screen');
        break;
      case 'market':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Market prices feature coming soon'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case 'voice':
        Navigator.pushNamed(context, '/voice-input-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'Crop Advisory',
        centerTitle: false,
      ),
      body: _isLoading
          ? _buildLoadingState(theme)
          : _selectedCropId == null
              ? _buildCropSelectionView(theme)
              : _buildCropDetailView(theme),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          SizedBox(height: 2.h),
          Text(
            'Loading crop information...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropSelectionView(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Your Crop',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Get personalized care guidance for your crops',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Crop selection grid
          CropSelectionGridWidget(
            crops: _crops,
            onCropSelected: _handleCropSelection,
          ),

          SizedBox(height: 2.h),

          // Quick action buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: QuickActionButtonsWidget(onActionTap: _handleQuickAction),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildCropDetailView(ThemeData theme) {
    final selectedCrop = _crops.firstWhere(
      (crop) => crop['id'] == _selectedCropId,
      orElse: () => _crops[0],
    );

    final growthStages = _growthStages[_selectedCropId] ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crop header with back button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: _handleBackToCropSelection,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                      tooltip: 'Back to crop selection',
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCrop['name'] as String,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            selectedCrop['localName'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: (selectedCrop['isCurrentSeason'] as bool)
                        ? theme.colorScheme.primary.withValues(alpha: 0.2)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (selectedCrop['isCurrentSeason'] as bool)
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'wb_sunny',
                        color: (selectedCrop['isCurrentSeason'] as bool)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${selectedCrop['season']} Season',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: (selectedCrop['isCurrentSeason'] as bool)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Growth stage tracker
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Growth Stages',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          GrowthStageTrackerWidget(stages: growthStages),

          SizedBox(height: 3.h),

          // Fertilizer reminders
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Fertilizer Schedule',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          FertilizerReminderWidget(reminders: _fertilizerReminders),

          SizedBox(height: 3.h),

          // Care calendar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Monthly Care Calendar',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          CareCalendarWidget(calendar: _careCalendar),

          SizedBox(height: 2.h),

          // Quick action buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: QuickActionButtonsWidget(onActionTap: _handleQuickAction),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
