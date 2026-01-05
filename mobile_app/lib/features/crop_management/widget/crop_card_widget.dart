import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CropCardWidget extends StatelessWidget {
  final Map<String, dynamic> crop;
  final VoidCallback onTap;
  final VoidCallback onQuickTask;
  final VoidCallback onHealthCheck;

  const CropCardWidget({
    Key? key,
    required this.crop,
    required this.onTap,
    required this.onQuickTask,
    required this.onHealthCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(crop["id"]),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              onQuickTask();
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.task_alt,
            label: 'Quick Task',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              onHealthCheck();
            },
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
            icon: Icons.health_and_safety,
            label: 'Health',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          imageUrl: crop["image"] as String,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover,
                          semanticLabel: crop["semanticLabel"] as String,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crop["name"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'agriculture',
                                  color: theme.colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${crop["cropType"]} • ${crop["area"]}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            _buildHealthIndicator(theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildGrowthProgress(theme),
                  SizedBox(height: 2.h),
                  _buildUpcomingTasks(theme),
                  if ((crop["alerts"] as List).isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    _buildAlerts(theme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(ThemeData theme) {
    final healthScore = crop["healthScore"] as int;
    final healthStatus = crop["healthStatus"] as String;

    Color healthColor;
    if (healthScore >= 85) {
      healthColor = theme.colorScheme.primary;
    } else if (healthScore >= 70) {
      healthColor = Colors.orange;
    } else {
      healthColor = theme.colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: healthColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: healthColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'favorite',
            color: healthColor,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            '$healthScore% $healthStatus',
            style: theme.textTheme.bodySmall?.copyWith(
              color: healthColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthProgress(ThemeData theme) {
    final growthProgress = crop["growthProgress"] as double;
    final growthStage = crop["growthStage"] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Growth Stage: $growthStage',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(growthProgress * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: growthProgress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks(ThemeData theme) {
    final upcomingTasks = crop["upcomingTasks"] as List;

    if (upcomingTasks.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Tasks',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        ...upcomingTasks.take(2).map((task) {
          final taskMap = task as Map<String, dynamic>;
          final dueDate = taskMap["dueDate"] as DateTime;
          final daysUntil = dueDate.difference(DateTime.now()).inDays;

          return Padding(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle_outline',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    taskMap["task"] as String,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  daysUntil == 0
                      ? 'Today'
                      : daysUntil == 1
                          ? 'Tomorrow'
                          : 'in $daysUntil days',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: daysUntil <= 1
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: daysUntil <= 1 ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAlerts(ThemeData theme) {
    final alerts = crop["alerts"] as List;
    final firstAlert = alerts.first as Map<String, dynamic>;

    Color alertColor;
    final severity = firstAlert["severity"] as String;
    if (severity == "high") {
      alertColor = theme.colorScheme.error;
    } else if (severity == "medium") {
      alertColor = Colors.orange;
    } else {
      alertColor = Colors.yellow.shade700;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: alertColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              firstAlert["message"] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: alertColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
