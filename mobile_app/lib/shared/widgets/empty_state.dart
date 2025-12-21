import 'package:flutter/material.dart';

/// EmptyState
/// ----------
/// Purpose:
/// - Show friendly empty / no-data UI
/// - Guide farmer on what to do next
///
/// Features:
/// - Icon + title + message
/// - Optional action button
/// - Large tap area (farmer-friendly)
///
/// Usage:
/// EmptyState(
///   icon: Icons.eco_outlined,
///   title: 'No Carbon Data Yet',
///   message: 'Add your farm activities to start earning carbon credits.',
///   actionLabel: 'Add Farm Activity',
///   onAction: () {},
/// )

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌿 Icon
            Icon(
              icon,
              size: 72,
              color: Colors.green.shade400,
            ),

            const SizedBox(height: 20),

            // 🧾 Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
            ),

            const SizedBox(height: 12),

            // 📝 Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),

            // 👉 Optional Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
