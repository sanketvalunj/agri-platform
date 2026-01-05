import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../shared/widgets/custom_icon_widget.dart';

class ComposeFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ComposeFabWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: 'edit',
        size: 20,
        color: theme.colorScheme.onPrimary,
      ),
      label: Text('Post'),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
    );
  }
}
