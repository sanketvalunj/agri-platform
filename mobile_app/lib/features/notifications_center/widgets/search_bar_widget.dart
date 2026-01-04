import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Search bar with filter options for notifications
class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final bool showOnlyUnread;
  final Function(bool) onUnreadFilterChanged;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.showOnlyUnread,
    required this.onUnreadFilterChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search notifications...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: CustomIconWidget(
                            iconName: 'close',
                            size: 20,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          SizedBox(width: 2.w),

          // Unread filter toggle
          Container(
            decoration: BoxDecoration(
              color: widget.showOnlyUnread
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.showOnlyUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: IconButton(
              icon: CustomIconWidget(
                iconName: 'filter_list',
                size: 24,
                color: widget.showOnlyUnread
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onPressed: () {
                widget.onUnreadFilterChanged(!widget.showOnlyUnread);
              },
              tooltip: widget.showOnlyUnread ? 'Show all' : 'Show unread only',
            ),
          ),
        ],
      ),
    );
  }
}
