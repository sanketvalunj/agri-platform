import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_filter_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/search_bar_widget.dart';

/// Notifications Center Screen
/// Organizes alerts, reminders, and updates with categorized filtering
class NotificationsCenter extends StatefulWidget {
  const NotificationsCenter({Key? key}) : super(key: key);

  @override
  State<NotificationsCenter> createState() => _NotificationsCenterState();
}

class _NotificationsCenterState extends State<NotificationsCenter>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 4; // Notifications tab
  String _searchQuery = '';
  bool _showOnlyUnread = false;

  // Mock notification data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      "id": "1",
      "category": "weather",
      "title": "Heavy Rainfall Alert",
      "message":
          "Expect heavy rainfall in your area for the next 48 hours. Consider postponing irrigation activities.",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "isRead": false,
      "priority": "high",
      "icon": "cloud",
      "iconColor": "#FF6F00",
      "actionLabel": "View Forecast",
      "actionRoute": "/weather-insights",
    },
    {
      "id": "2",
      "category": "task",
      "title": "Fertilizer Application Due",
      "message":
          "Time to apply nitrogen fertilizer to your wheat crop. Optimal weather conditions detected.",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
      "priority": "medium",
      "icon": "eco",
      "iconColor": "#4CAF50",
      "cropImage":
          "https://images.unsplash.com/photo-1656772124131-25fd4f00ac14",
      "semanticLabel":
          "Close-up of golden wheat stalks in a field under bright sunlight",
      "actionLabel": "Mark Complete",
      "dueDate": DateTime.now().add(Duration(days: 2)),
    },
    {
      "id": "3",
      "category": "community",
      "title": "Rajesh Kumar shared farming tips",
      "message": "New post about organic pest control methods for cotton crops",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "isRead": true,
      "priority": "low",
      "icon": "people",
      "iconColor": "#2E7D32",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_12edd2a4d-1763295490616.png",
      "avatarSemanticLabel":
          "Profile photo of a man with short brown hair wearing a green shirt",
      "actionLabel": "View Post",
      "actionRoute": "/community-feed",
    },
    {
      "id": "4",
      "category": "ai",
      "title": "Personalized Farming Insight",
      "message":
          "Based on your crop data, consider intercropping with legumes to improve soil nitrogen levels.",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "isRead": true,
      "priority": "medium",
      "icon": "lightbulb",
      "iconColor": "#FFB300",
      "actionLabel": "Learn More",
      "expandable": true,
      "expandedContent":
          "Intercropping with legumes like chickpeas or lentils can naturally fix nitrogen in the soil, reducing fertilizer costs by up to 30%. This practice also improves soil structure and biodiversity.",
    },
    {
      "id": "5",
      "category": "weather",
      "title": "Temperature Drop Warning",
      "message": "Frost conditions expected tonight. Protect sensitive crops.",
      "timestamp": DateTime.now().subtract(Duration(hours: 12)),
      "isRead": false,
      "priority": "high",
      "icon": "ac_unit",
      "iconColor": "#1976D2",
      "actionLabel": "View Details",
      "actionRoute": "/weather-insights",
    },
    {
      "id": "6",
      "category": "task",
      "title": "Irrigation Schedule Reminder",
      "message": "Scheduled irrigation for tomato field at 6:00 AM tomorrow",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": true,
      "priority": "medium",
      "icon": "water_drop",
      "iconColor": "#0288D1",
      "cropImage":
          "https://images.unsplash.com/photo-1622676539719-280635549b9f",
      "semanticLabel":
          "Ripe red tomatoes growing on green vines in a greenhouse",
      "actionLabel": "Reschedule",
      "dueDate": DateTime.now().add(Duration(hours: 14)),
    },
    {
      "id": "7",
      "category": "community",
      "title": "Priya Sharma commented on your post",
      "message":
          "Great advice on drip irrigation setup! Can you share more details?",
      "timestamp": DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "isRead": true,
      "priority": "low",
      "icon": "comment",
      "iconColor": "#388E3C",
      "userAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ac0f6910-1763299885644.png",
      "avatarSemanticLabel":
          "Profile photo of a woman with long black hair wearing traditional attire",
      "actionLabel": "Reply",
      "actionRoute": "/community-feed",
    },
    {
      "id": "8",
      "category": "ai",
      "title": "Crop Health Analysis Complete",
      "message":
          "Your recent crop images have been analyzed. Minor pest activity detected in sector B.",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "isRead": false,
      "priority": "medium",
      "icon": "analytics",
      "iconColor": "#F57C00",
      "actionLabel": "View Report",
      "expandable": true,
      "expandedContent":
          "Analysis shows early signs of aphid infestation in 3% of plants. Recommend organic neem oil spray application within 48 hours to prevent spread.",
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    List<Map<String, dynamic>> filtered = _allNotifications;

    // Filter by category
    String category =
        ['weather', 'task', 'community', 'ai'][_tabController.index];
    filtered = filtered.where((n) => n['category'] == category).toList();

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((n) {
        final title = (n['title'] as String).toLowerCase();
        final message = (n['message'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || message.contains(query);
      }).toList();
    }

    // Filter by read status
    if (_showOnlyUnread) {
      filtered = filtered.where((n) => !(n['isRead'] as bool)).toList();
    }

    return filtered;
  }

  int get _unreadCount {
    return _allNotifications.where((n) => !(n['isRead'] as bool)).length;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _allNotifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
    HapticFeedback.lightImpact();
  }

  void _deleteNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((n) => n['id'] == id);
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _snoozeNotification(String id) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification snoozed for 1 hour'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveNotification(String id) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareNotification(String id) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['isRead'] = true;
      }
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allNotifications.clear();
              });
              Navigator.pop(context);
              HapticFeedback.heavyImpact();
            },
            child: Text('CLEAR ALL',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          if (_unreadCount > 0)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (value) {
              if (value == 'mark_all_read') {
                _markAllAsRead();
              } else if (value == 'clear_all') {
                _clearAll();
              } else if (value == 'settings') {
                // Navigate to notification settings
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    CustomIconWidget(
                        iconName: 'done_all',
                        size: 20,
                        color: theme.colorScheme.onSurface),
                    SizedBox(width: 3.w),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    CustomIconWidget(
                        iconName: 'delete_sweep',
                        size: 20,
                        color: theme.colorScheme.error),
                    SizedBox(width: 3.w),
                    Text('Clear all',
                        style: TextStyle(color: theme.colorScheme.error)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                        iconName: 'settings',
                        size: 20,
                        color: theme.colorScheme.onSurface),
                    SizedBox(width: 3.w),
                    Text('Notification settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            showOnlyUnread: _showOnlyUnread,
            onUnreadFilterChanged: (value) {
              setState(() {
                _showOnlyUnread = value;
              });
            },
          ),

          // Category filter tabs
          CategoryFilterWidget(
            tabController: _tabController,
            onTabChanged: () {
              setState(() {});
            },
          ),

          // Notifications list
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {});
                      HapticFeedback.mediumImpact();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return Slidable(
                          key: Key(notification['id'] as String),
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    _markAsRead(notification['id'] as String),
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                icon: Icons.done,
                                label: 'Read',
                              ),
                              SlidableAction(
                                onPressed: (_) => _saveNotification(
                                    notification['id'] as String),
                                backgroundColor: theme.colorScheme.tertiary,
                                foregroundColor: Colors.black,
                                icon: Icons.bookmark,
                                label: 'Save',
                              ),
                              SlidableAction(
                                onPressed: (_) => _shareNotification(
                                    notification['id'] as String),
                                backgroundColor: theme.colorScheme.secondary,
                                foregroundColor: Colors.black,
                                icon: Icons.share,
                                label: 'Share',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _snoozeNotification(
                                    notification['id'] as String),
                                backgroundColor: theme.colorScheme.tertiary
                                    .withValues(alpha: 0.7),
                                foregroundColor: Colors.black,
                                icon: Icons.snooze,
                                label: 'Snooze',
                              ),
                              SlidableAction(
                                onPressed: (_) => _deleteNotification(
                                    notification['id'] as String),
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: NotificationCardWidget(
                            notification: notification,
                            onTap: () {
                              _markAsRead(notification['id'] as String);
                              final route =
                                  notification['actionRoute'] as String?;
                              if (route != null) {
                                Navigator.pushNamed(context, route);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          if (index != _currentBottomIndex) {
            HapticFeedback.selectionClick();
            final route = CustomBottomBar.getRouteForIndex(index);
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'notifications_none',
            size: 80,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'No matching notifications'
                : 'No notifications yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
