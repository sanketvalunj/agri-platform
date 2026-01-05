import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrendingTopicsWidget extends StatelessWidget {
  final List<String> topics;
  final Function(String) onTopicTap;

  const TrendingTopicsWidget({
    Key? key,
    required this.topics,
    required this.onTopicTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: ActionChip(
              label: Text(
                topic,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              onPressed: () => onTopicTap(topic),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            ),
          );
        },
      ),
    );
  }
}
