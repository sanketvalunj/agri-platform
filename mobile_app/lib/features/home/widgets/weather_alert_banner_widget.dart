import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

/// Emergency weather alert banner with color-coded severity
class WeatherAlertBannerWidget extends StatelessWidget {
  final String alertMessage;
  final String severity; // 'low', 'medium', 'high'
  final VoidCallback onTap;

  const WeatherAlertBannerWidget({
    super.key,
    required this.alertMessage,
    required this.severity,
    required this.onTap,
  });

  Color _getSeverityColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (severity.toLowerCase()) {
      case 'high':
        return theme.colorScheme.error;
      case 'medium':
        return const Color(0xFFFF8F00);
      case 'low':
      default:
        return const Color(0xFFFFC107);
    }
  }

  String _getSeverityIcon() {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'warning';
      case 'medium':
        return 'error_outline';
      case 'low':
      default:
        return 'info_outline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _getSeverityColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: severityColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: severityColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: _getSeverityIcon(),
                color: severityColor,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'मौसम चेतावनी',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: severityColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    alertMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: severityColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
