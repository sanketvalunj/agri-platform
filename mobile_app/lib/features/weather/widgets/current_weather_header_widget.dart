import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/widgets/custom_icon_widget.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weatherData['location'] ?? 'Unknown Location',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        weatherData['condition'] ?? 'Unknown',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  CustomIconWidget(
                    iconName: weatherData['icon'] ?? 'wb_cloudy',
                    size: 48,
                    color: theme.colorScheme.onPrimary,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherMetric(
                    context,
                    '${weatherData['temperature']}°C',
                    'Temperature',
                    theme,
                  ),
                  _buildWeatherMetric(
                    context,
                    '${weatherData['humidity']}%',
                    'Humidity',
                    theme,
                  ),
                  _buildWeatherMetric(
                    context,
                    '${weatherData['windSpeed']} km/h',
                    'Wind Speed',
                    theme,
                  ),
                  _buildWeatherMetric(
                    context,
                    '${weatherData['uvIndex']}',
                    'UV Index',
                    theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherMetric(
      BuildContext context, String value, String label, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
