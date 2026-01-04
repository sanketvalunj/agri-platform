import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimelineItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final bool isLast;

  const TimelineItemWidget({
    Key? key,
    required this.activity,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = activity["status"] as String;
    final isCompleted = status == "completed";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: theme.colorScheme.onPrimary,
                        size: 18,
                      )
                    : CustomIconWidget(
                        iconName: 'schedule',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 18,
                      ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 3.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity["activity"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isCompleted ? 'Completed' : 'Pending',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isCompleted
                                ? theme.colorScheme.primary
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'agriculture',
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          activity["cropName"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatDate(activity["date"] as DateTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  if (activity["notes"] != null &&
                      (activity["notes"] as String).isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      activity["notes"] as String,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if ((activity["photos"] as List).isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    SizedBox(
                      height: 15.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: (activity["photos"] as List).length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 2.w),
                        itemBuilder: (context, index) {
                          final photo = (activity["photos"] as List)[index]
                              as Map<String, dynamic>;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: photo["url"] as String,
                              width: 20.w,
                              height: 15.h,
                              fit: BoxFit.cover,
                              semanticLabel: photo["semanticLabel"] as String,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        activity["performedBy"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
