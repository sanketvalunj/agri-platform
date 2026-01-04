import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different contexts
enum CustomAppBarVariant {
  standard,
  contextual,
  search,
  minimal,
}

/// Custom app bar optimized for agricultural mobile context
/// Implements adaptive headers with critical information display
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final CustomAppBarVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  // Contextual information for agricultural app
  final String? weatherInfo;
  final String? locationInfo;
  final bool? isOnline;
  final VoidCallback? onWeatherTap;
  final VoidCallback? onLocationTap;

  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.variant = CustomAppBarVariant.standard,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.bottom,
    this.weatherInfo,
    this.locationInfo,
    this.isOnline,
    this.onWeatherTap,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (variant == CustomAppBarVariant.contextual &&
        (weatherInfo != null || locationInfo != null)) {
      height += 40; // Additional height for contextual info
    }
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    final effectiveBackgroundColor = backgroundColor ??
        appBarTheme.backgroundColor ??
        theme.colorScheme.surface;
    final effectiveForegroundColor = foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;

    return AppBar(
      title: _buildTitle(context),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: _buildActions(context),
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      bottom: _buildBottom(context),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.minimal:
        return Text(
          title!,
          style: theme.appBarTheme.titleTextStyle,
        );

      case CustomAppBarVariant.contextual:
        return Column(
          crossAxisAlignment: centerTitle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title!,
              style: theme.appBarTheme.titleTextStyle,
            ),
            if (weatherInfo != null || locationInfo != null)
              SizedBox(height: 2),
            if (weatherInfo != null || locationInfo != null)
              _buildContextualInfo(context),
          ],
        );

      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: title ?? 'Search...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: theme.textTheme.bodyMedium,
            onChanged: (value) {
              // Handle search
            },
          ),
        );
    }
  }

  Widget _buildContextualInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (locationInfo != null)
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onLocationTap?.call();
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 2),
                  Text(
                    locationInfo!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (locationInfo != null && weatherInfo != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '•',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ),
        if (weatherInfo != null)
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onWeatherTap?.call();
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wb_sunny,
                    size: 12,
                    color: theme.colorScheme.tertiary,
                  ),
                  SizedBox(width: 2),
                  Text(
                    weatherInfo!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (isOnline != null)
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isOnline!
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (variant == CustomAppBarVariant.minimal) {
      return null;
    }

    final theme = Theme.of(context);
    final defaultActions = <Widget>[];

    // Add connectivity indicator for all variants except minimal
    if (isOnline != null && variant != CustomAppBarVariant.contextual) {
      defaultActions.add(
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isOnline!
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    if (actions != null) {
      defaultActions.addAll(actions!);
    }

    return defaultActions.isEmpty ? null : defaultActions;
  }

  PreferredSizeWidget? _buildBottom(BuildContext context) {
    return bottom;
  }

  /// Factory constructor for home dashboard app bar
  factory CustomAppBar.home({
    required BuildContext context,
    String? weatherInfo,
    String? locationInfo,
    bool? isOnline,
    VoidCallback? onWeatherTap,
    VoidCallback? onLocationTap,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: 'AgriAssist',
      variant: CustomAppBarVariant.contextual,
      weatherInfo: weatherInfo,
      locationInfo: locationInfo,
      isOnline: isOnline,
      onWeatherTap: onWeatherTap,
      onLocationTap: onLocationTap,
      actions: actions ??
          [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/notifications-center');
              },
              tooltip: 'Notifications',
            ),
          ],
    );
  }

  /// Factory constructor for search app bar
  factory CustomAppBar.search({
    String? hint,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: hint ?? 'Search',
      variant: CustomAppBarVariant.search,
      actions: actions,
    );
  }

  /// Factory constructor for minimal app bar
  factory CustomAppBar.minimal({
    String? title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.minimal,
      leading: leading,
      actions: actions,
      elevation: 0,
    );
  }
}
