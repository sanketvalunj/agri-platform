import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

/// Agricultural advisory recommendations with bullet points and simple language
class AdvisoryRecommendationsWidget extends StatelessWidget {
  final Map<String, dynamic> advice;

  const AdvisoryRecommendationsWidget({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agricultural Advisory',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildAdvisoryItem(
              context,
              icon: 'water',
              title: 'Irrigation',
              description: advice["irrigation"] as String,
            ),
            const SizedBox(height: 12),
            _buildAdvisoryItem(
              context,
              icon: 'bug_report',
              title: 'Pest Activity',
              description: advice["pest"] as String,
            ),
            const SizedBox(height: 12),
            _buildAdvisoryItem(
              context,
              icon: 'agriculture',
              title: 'Farming Activities',
              description: advice["activities"] as String,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
