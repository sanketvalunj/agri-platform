import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityHighlightCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;

  const CommunityHighlightCard({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 80.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post['image'] != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 35.h, // Limit image height responsively
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: CustomImageWidget(
                      imageUrl: post['image'] as String,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: post['semanticLabel'] as String,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['author'] as String,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                post['timestamp'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      post['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      post['content'] as String,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _buildStatItem(
                          context,
                          'thumb_up',
                          post['likes'].toString(),
                        ),
                        SizedBox(width: 4.w),
                        _buildStatItem(
                          context,
                          'comment',
                          post['comments'].toString(),
                        ),
                        Spacer(),
                        CustomIconWidget(
                          iconName: 'chevron_right',
                          color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String iconName, String count) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 18,
        ),
        SizedBox(width: 1.w),
        Text(
          count,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
