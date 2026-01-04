import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CurrentWeatherHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const CurrentWeatherHeaderWidget({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          // Location with GPS accuracy
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  weatherData["location"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  weatherData["gpsAccuracy"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Large temperature display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weatherData["temperature"]}',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 72.sp,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
              Text(
                '°C',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Weather condition with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: weatherData["icon"] as String,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 2.w),
              Text(
                weatherData["condition"] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Feels like temperature
          Text(
            'Feels like ${weatherData["feelsLike"]}°C',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: 3.h),

          // Weather details grid
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  context,
                  'water_drop',
                  'Humidity',
                  '${weatherData["humidity"]}%',
                ),
                _buildDivider(theme),
                _buildWeatherDetail(
                  context,
                  'air',
                  'Wind',
                  '${weatherData["windSpeed"]} km/h',
                ),
                _buildDivider(theme),
                _buildWeatherDetail(
                  context,
                  'wb_sunny',
                  'UV Index',
                  '${weatherData["uvIndex"]}',
                ),
                _buildDivider(theme),
                _buildWeatherDetail(
                  context,
                  'grass',
                  'Soil',
                  '${weatherData["soilMoisture"]}%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    String icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: Colors.white.withValues(alpha: 0.9),
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.25.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 6.h,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}
