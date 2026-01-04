import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostCardWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCardWidget({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImages = (post['images'] as List).isNotEmpty;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme),
          _buildContent(context, theme),
          if (hasImages) _buildImages(context),
          _buildHashtags(context, theme),
          _buildActions(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: post['verified'] == true
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: post['userAvatar'],
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  semanticLabel: post['userAvatarLabel'],
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post['userName'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (post['verified'] == true) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'verified',
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      size: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      post['location'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '•',
                      style: TextStyle(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatTimestamp(post['timestamp']),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showPostOptions(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Text(
        post['text'],
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildImages(BuildContext context) {
    final images = post['images'] as List;

    return Container(
      margin: EdgeInsets.only(top: 2.h),
      height: 50.h,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _showImageFullScreen(context, image);
            },
            child: CustomImageWidget(
              imageUrl: image['url'],
              width: double.infinity,
              height: 50.h,
              fit: BoxFit.cover,
              semanticLabel: image['label'],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHashtags(BuildContext context, ThemeData theme) {
    final hashtags = post['hashtags'] as List;

    if (hashtags.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: hashtags.map((tag) {
          return GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Text(
              tag,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: Row(
        children: [
          _buildActionButton(
            context,
            theme,
            post['isLiked'] == true ? 'favorite' : 'favorite_border',
            '${post['likes']}',
            onLike,
            isActive: post['isLiked'] == true,
          ),
          SizedBox(width: 4.w),
          _buildActionButton(
            context,
            theme,
            'chat_bubble_outline',
            '${post['comments']}',
            onComment,
          ),
          SizedBox(width: 4.w),
          _buildActionButton(
            context,
            theme,
            'share',
            '${post['shares']}',
            onShare,
          ),
          Spacer(),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'bookmark_border',
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    String iconName,
    String count,
    VoidCallback onPressed, {
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              size: 20,
              color: isActive
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: 1.w),
            Text(
              count,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bookmark_border',
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text('Save Post'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility_off',
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text('Hide Post'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'person_add',
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text('Follow ${post['userName']}'),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  size: 24,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Report Post',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, Map<String, dynamic> image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: CustomIconWidget(
                iconName: 'close',
                size: 24,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: CustomImageWidget(
                imageUrl: image['url'],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                semanticLabel: image['label'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
