import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual notification card with expandable content
class NotificationCardWidget extends StatefulWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends State<NotificationCardWidget> {
  bool _isExpanded = false;

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  Color _getPriorityColor(String priority, ThemeData theme) {
    switch (priority) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return theme.colorScheme.tertiary;
      case 'low':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = widget.notification['isRead'] as bool;
    final priority = widget.notification['priority'] as String;
    final timestamp = widget.notification['timestamp'] as DateTime;
    final expandable = widget.notification['expandable'] as bool? ?? false;
    final cropImage = widget.notification['cropImage'] as String?;
    final userAvatar = widget.notification['userAvatar'] as String?;
    final dueDate = widget.notification['dueDate'] as DateTime?;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isRead
            ? theme.colorScheme.surface
            : theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead
              ? theme.colorScheme.outline.withValues(alpha: 0.2)
              : theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon or Avatar
                    if (userAvatar != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomImageWidget(
                          imageUrl: userAvatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          semanticLabel:
                              widget.notification['avatarSemanticLabel']
                                      as String? ??
                                  'User avatar',
                        ),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                                  '0xFF${(widget.notification['iconColor'] as String).substring(1)}'))
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: widget.notification['icon'] as String,
                            size: 24,
                            color: Color(int.parse(
                                '0xFF${(widget.notification['iconColor'] as String).substring(1)}')),
                          ),
                        ),
                      ),
                    SizedBox(width: 3.w),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification['title'] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.only(left: 2.w),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            widget.notification['message'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: _isExpanded ? null : 2,
                            overflow:
                                _isExpanded ? null : TextOverflow.ellipsis,
                          ),

                          // Expanded content
                          if (_isExpanded &&
                              expandable &&
                              widget.notification['expandedContent'] != null)
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.notification['expandedContent']
                                    as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ),

                          // Crop image
                          if (cropImage != null)
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              height: 15.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomImageWidget(
                                  imageUrl: cropImage,
                                  width: double.infinity,
                                  height: 15.h,
                                  fit: BoxFit.cover,
                                  semanticLabel:
                                      widget.notification['semanticLabel']
                                              as String? ??
                                          'Crop image',
                                ),
                              ),
                            ),

                          SizedBox(height: 1.h),

                          // Footer
                          Row(
                            children: [
                              // Priority indicator
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.3.h),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(priority, theme)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  priority.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: _getPriorityColor(priority, theme),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),

                              // Timestamp
                              Text(
                                _formatTimestamp(timestamp),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),

                              // Due date
                              if (dueDate != null) ...[
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  size: 14,
                                  color: theme.colorScheme.tertiary,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Due ${DateFormat('MMM d, h:mm a').format(dueDate)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.tertiary,
                                  ),
                                ),
                              ],

                              Spacer(),

                              // Expand button
                              if (expandable)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.w),
                                    child: CustomIconWidget(
                                      iconName: _isExpanded
                                          ? 'expand_less'
                                          : 'expand_more',
                                      size: 20,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Action button
                          if (widget.notification['actionLabel'] != null)
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              child: OutlinedButton(
                                onPressed: widget.onTap,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 40),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                ),
                                child: Text(widget.notification['actionLabel']
                                    as String),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
