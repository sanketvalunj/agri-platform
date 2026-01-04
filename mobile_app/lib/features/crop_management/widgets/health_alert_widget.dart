import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HealthAlertWidget extends StatelessWidget {
  final Map<String, dynamic> alert;

  const HealthAlertWidget({
    Key? key,
    required this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = alert["type"] as String;
    final severity = alert["severity"] as String;
    final message = alert["message"] as String;

    Color alertColor;
    IconData alertIcon;

    if (severity == "high") {
      alertColor = theme.colorScheme.error;
    } else if (severity == "medium") {
      alertColor = Colors.orange;
    } else {
      alertColor = Colors.yellow.shade700;
    }

    if (type == "pest") {
      alertIcon = Icons.bug_report;
    } else if (type == "disease") {
      alertIcon = Icons.coronavirus;
    } else {
      alertIcon = Icons.warning;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              alertIcon,
              color: alertColor,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == "pest"
                      ? 'Pest Alert'
                      : type == "disease"
                          ? 'Disease Alert'
                          : 'Health Alert',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: alertColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
