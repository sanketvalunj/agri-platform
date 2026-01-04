import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyData;

  const HourlyForecastWidget({
    Key? key,
    required this.hourlyData,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hourly Forecast',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text(
                    '24 Hours',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: hourlyData.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final hour = hourlyData[index];
                final isNow = hour["time"] == "Now";

                return Container(
                  width: 20.w,
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: isNow
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isNow
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isNow ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        hour["time"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: isNow ? FontWeight.w600 : FontWeight.w400,
                          color: isNow
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                      ),
                      CustomIconWidget(
                        iconName: hour["icon"] as String,
                        color: isNow
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        size: 32,
                      ),
                      Text(
                        '${hour["temperature"]}°',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'water_drop',
                            color: theme.colorScheme.primary,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${hour["precipitation"]}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'air',
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${hour["windSpeed"]}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
