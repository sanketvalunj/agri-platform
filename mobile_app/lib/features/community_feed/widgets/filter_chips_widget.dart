import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ['All', 'Location', 'Crop Type', 'Tips', 'Market'];

    return Container(
      height: 5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index].toLowerCase();
          final isSelected = selectedFilter == filter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (selected) {
                HapticFeedback.lightImpact();
                onFilterChanged(filter);
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
