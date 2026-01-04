import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeatherAlertsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;

  const WeatherAlertsWidget({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Weather Alerts',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(context, alert);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, Map<String, dynamic> alert) {
    final theme = Theme.of(context);
    final severity = alert["severity"] as String;

    Color alertColor;
    Color alertBgColor;
    switch (severity) {
      case 'high':
        alertColor = theme.colorScheme.error;
        alertBgColor = theme.colorScheme.error.withValues(alpha: 0.1);
        break;
      case 'medium':
        alertColor = theme.colorScheme.tertiary;
        alertBgColor = theme.colorScheme.tertiary.withValues(alpha: 0.1);
        break;
      default:
        alertColor = theme.colorScheme.primary;
        alertBgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: alertBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: alertColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: alert["icon"] as String,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  alert["title"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: alertColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            alert["message"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _handleAlertAction(context, alert);
                  },
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color: alertColor,
                    size: 18,
                  ),
                  label: Text(alert["action"] as String),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: alertColor,
                    side: BorderSide(color: alertColor),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _enableNotification(context, alert);
                },
                icon: CustomIconWidget(
                  iconName: 'notifications_active',
                  color: alertColor,
                  size: 24,
                ),
                tooltip: 'Enable Notification',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAlertAction(BuildContext context, Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: alert["icon"] as String,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              alert["title"] as String,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Alert Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        alert["message"] as String,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: Text('Got It'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _enableNotification(BuildContext context, Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification enabled for ${alert["title"]}'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {},
        ),
      ),
    );
  }
}
