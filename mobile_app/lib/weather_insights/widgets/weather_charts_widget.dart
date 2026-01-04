import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeatherChartsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> hourlyData;

  const WeatherChartsWidget({
    Key? key,
    required this.hourlyData,
  }) : super(key: key);

  @override
  State<WeatherChartsWidget> createState() => _WeatherChartsWidgetState();
}

class _WeatherChartsWidgetState extends State<WeatherChartsWidget> {
  String _selectedChart = 'temperature';

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
            child: Text(
              'Weather Trends',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Chart type selector
          Container(
            height: 6.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              children: [
                _buildChartTypeButton(
                  context,
                  'temperature',
                  'Temperature',
                  'thermostat',
                ),
                SizedBox(width: 2.w),
                _buildChartTypeButton(
                  context,
                  'precipitation',
                  'Rainfall',
                  'water_drop',
                ),
                SizedBox(width: 2.w),
                _buildChartTypeButton(
                  context,
                  'wind',
                  'Wind Speed',
                  'air',
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Chart container
          Container(
            height: 30.h,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: _selectedChart == 'temperature'
                ? _buildTemperatureChart(context)
                : _selectedChart == 'precipitation'
                    ? _buildPrecipitationChart(context)
                    : _buildWindChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(
    BuildContext context,
    String type,
    String label,
    String icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedChart == type;

    return InkWell(
      onTap: () => setState(() => _selectedChart = type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureChart(BuildContext context) {
    final theme = Theme.of(context);
    final spots = widget.hourlyData
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value["temperature"] as int).toDouble(),
            ))
        .toList();

    return Semantics(
      label:
          "Temperature trend line chart showing hourly temperature variations",
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= widget.hourlyData.length) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      widget.hourlyData[value.toInt()]["time"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}°',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (widget.hourlyData.length - 1).toDouble(),
          minY: 20,
          maxY: 40,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrecipitationChart(BuildContext context) {
    final theme = Theme.of(context);
    final barGroups = widget.hourlyData
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: (entry.value["precipitation"] as int).toDouble(),
                  color: theme.colorScheme.primary,
                  width: 4.w,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ))
        .toList();

    return Semantics(
      label: "Precipitation bar chart showing hourly rainfall probability",
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= widget.hourlyData.length) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      widget.hourlyData[value.toInt()]["time"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 25,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _buildWindChart(BuildContext context) {
    final theme = Theme.of(context);
    final spots = widget.hourlyData
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value["windSpeed"] as int).toDouble(),
            ))
        .toList();

    return Semantics(
      label: "Wind speed line chart showing hourly wind speed variations",
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= widget.hourlyData.length) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Text(
                      widget.hourlyData[value.toInt()]["time"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (widget.hourlyData.length - 1).toDouble(),
          minY: 0,
          maxY: 25,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: theme.colorScheme.tertiary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.tertiary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
