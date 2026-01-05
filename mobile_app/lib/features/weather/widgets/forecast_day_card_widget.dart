import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

/// Individual day forecast card with tap-to-expand functionality
class ForecastDayCardWidget extends StatelessWidget {
  final String day;
  final String icon;
  final int tempHigh;
  final int tempLow;
  final int rainfall;
  final String condition;
  final bool isExpanded;
  final VoidCallback onTap;

  const ForecastDayCardWidget({
    super.key,
    required this.day,
    required this.icon,
    required this.tempHigh,
    required this.tempLow,
    required this.rainfall,
    required this.condition,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        decoration: BoxDecoration(
          color: isExpanded
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded ? theme.colorScheme.primary : theme.dividerColor,
            width: isExpanded ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isExpanded
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.primary,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                '$tempHigh°',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '$tempLow°',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'water_drop',
                    color: theme.colorScheme.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$rainfall%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
